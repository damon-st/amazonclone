const express = require("express");
const router = express.Router();
const User = require("../models/user");
const bycryptJs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { auth } = require("../middlewares/auth");

router.post("/api/signup", async (req, res) => {
  //get the data from client
  try {
    const { name, password, email } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        status: "user already exits",
        msg: "User with same email already exist!",
      });
    }
    const passworEncrypt = await bycryptJs.hash(password, 8);
    let user = new User({
      email,
      password: passworEncrypt,
      name,
    });
    user = await user.save();
    return res.status(200).json({
      status: "success",
      user,
    });
  } catch (error) {
    return res.status(500).send({
      status: "error",
      error: error.toString(),
    });
  }
  //post that data in database
  //return that data to the user
});

//sign in route
router.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        status: "User not found",
        msg: "User with this email does not exist!",
      });
    }
    const isMathc = await bycryptJs.compare(password, user.password);
    if (!isMathc) {
      return res.status(400).json({
        status: "Password incorrect",
        msg: "Icorrect password",
      });
    }
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
    return res.status(200).send({ token, ...user._doc });
  } catch (e) {
    return res.status(500).json({
      status: "error",
      error: e.toString(),
    });
  }
});

//verifidata
router.post("/api/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(400).json({
        msg: "Token not found",
        status: "error",
      });
    }

    const verified = jwt.verify(token, process.env.JWT_SECRET);
    if (!verified) {
      return res.status(400).json({
        msg: "Token is invalid",
        status: "error",
      });
    }

    const user = await User.findById(verified.id);
    if (!user) {
      return res.status(400).json({
        msg: "User not found",
        status: "error",
      });
    }
    return res.status(200).json({
      status: "success",
      msg: "User fond",
      user,
    });
  } catch (e) {
    return res.status(500).json({
      status: "error",
      error: e.toString(),
    });
  }
});

router.get("/api/getUserData", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(400).json({
        msg: "User not found",
        status: "error",
      });
    }
    return res.status(200).json({
      ...user._doc,
      token: req.token,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "error",
      error: e.toString(),
      status: "error",
    });
  }
});

module.exports = router;
