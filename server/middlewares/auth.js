const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({
        status: "error",
        msg: "No atuh token, access deniend",
      });
    }

    const verified = jwt.verify(token, process.env.JWT_SECRET);
    if (!verified) {
      return res.status(401).json({
        msg: "Token is invalid",
        status: "error",
      });
    }
    req.user = verified.id;
    req.token = token;
    next();
  } catch (e) {
    return res.status(500).json({
      status: "error",
      error: e.toString(),
    });
  }
};

module.exports = { auth };
