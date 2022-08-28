const express = require("express");
const { admin } = require("../middlewares/admin");
const Order = require("../models/order");
const router = express.Router();
const { Product } = require("../models/product");
router.post("/api/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;

    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    return res.status(200).json({
      msg: "Create product succefully",
      status: "success",
      product,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

//get all products
router.get("/api/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    return res.status(200).json({
      status: "success",
      msg: "Succes get all products",
      products,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

//Delete the product
router.delete("/api/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    await Product.findByIdAndDelete(id);
    return res.status(200).json({
      status: "success",
      msg: "Delete success",
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});
router.post("/api/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findByIdAndUpdate(id, {
      status,
    });
    return res.status(200).json({
      status: "success",
      msg: "Delete success",
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

router.get("/api/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    return res.status(200).json({
      status: "success",
      msg: "Succes get all orders",
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

router.get("/api/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;
    for (let i = 0; i < orders.length; i++) {
      const element = orders[i];
      for (let j = 0; j < element.products.length; j++) {
        const p = element.products[j];
        totalEarnings += p.quantity * p.product.price;
      }
    }

    //CATEGORY WISE ORDER FETHICH
    let mobilesEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialsEarnings = await fetchCategoryWiseProduct("Essentials");
    let appliancesEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobilesEarnings,
      essentialsEarnings,
      appliancesEarnings,
      booksEarnings,
      fashionEarnings,
    };

    return res.status(200).json({
      status: "success",
      msg: "Success",
      earnings,
    });
  } catch (e) {
    return res.status(500).json({
      msg: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

const fetchCategoryWiseProduct = async (category) => {
  let earnings = 0;
  let categoryOrdeers = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrdeers.length; i++) {
    const element = categoryOrdeers[i];
    for (let j = 0; j < element.products.length; j++) {
      const p = element.products[j];
      earnings += p.quantity * p.product.price;
    }
  }

  return earnings;
};

module.exports = router;
