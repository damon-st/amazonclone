const express = require("express");
const { auth } = require("../middlewares/auth");
const Order = require("../models/order");
const router = express.Router();
const { Product } = require("../models/product");
const User = require("../models/user");
router.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({
        product,
        quantity: 1,
      });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        const e = user.cart[i];
        if (e.product._id.equals(product._id)) {
          isProductFound = true;
        }
      }
      if (isProductFound) {
        let producttt = user.cart.find((p) =>
          p.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({
          product,
          quantity: 1,
        });
      }
    }
    user = await user.save();
    return res.status(200).json({
      status: "success",
      message: "Success",
      user,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});
router.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      const e = user.cart[i];
      if (e.product._id.equals(product._id)) {
        if (e.quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          e.quantity -= 1;
        }
      }
    }
    user = await user.save();
    return res.status(200).json({
      status: "success",
      message: "Success",
      user,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

//save user address
router.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;

    let user = await User.findByIdAndUpdate(req.user, {
      address,
    });

    return res.status(200).json({
      status: "success",
      message: "Success",
      user,
    });
  } catch (error) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

//order product
router.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;

    let products = [];

    for (let i = 0; i < cart.length; i++) {
      const element = cart[i];
      let product = await Product.findById(element.product._id);
      if (product.quantity >= element.quantity) {
        product.quantity -= element.quantity;
        products.push({
          product,
          quantity: element.quantity,
        });
        await product.save();
      } else {
        return res.status(400).json({
          msg: `${product.name} is out of sctcok!`,
          status: "error",
        });
      }
    }
    let user = await User.findByIdAndUpdate(req.user, {
      cart: [],
    });
    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();

    return res.status(200).json({
      status: "success",
      msg: "Success",
      order,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

router.get("/api/orders/me", auth, async (req, res) => {
  try {
    let orders = await Order.find({ userId: req.user });

    return res.status(200).json({
      status: "success",
      msg: "Success",
      orders,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

module.exports = router;
