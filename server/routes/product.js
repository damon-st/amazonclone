const express = require("express");
const router = express.Router();
const { auth } = require("../middlewares/auth");
const { Product } = require("../models/product");

router.get("/api/products", auth, async (req, res) => {
  try {
    const products = await Product.find({
      category: req.query.category,
    });

    return res.status(200).json({
      status: "success",
      products,
      message: "Get products with category",
    });
  } catch (e) {
    return res.status(500).json({
      message: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});
router.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    return res.status(200).json({
      status: "success",
      products,
      message: "Get products with category",
    });
  } catch (e) {
    return res.status(500).json({
      message: "Error",
      status: "error",
      error: e.toString(),
    });
  }
});

//create a post request route to rate the product
router.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);
    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }
    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();

    return res.status(200).json({
      status: "success",
      message: "Updated correct",
      product,
    });
  } catch (e) {
    return res.status(500).send({
      status: "Error",
      message: "Error",
      error: e.toString(),
    });
  }
});

router.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;
      for (let i = 0; i < a.ratings.length; i++) {
        const element = a.ratings[i];
        aSum += element.rating;
      }
      for (let i = 0; i < b.ratings.length; i++) {
        const element = b.ratings[i];
        bSum += element.rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    return res.status(200).json({
      status: "success",
      message: "Updated correct",
      product: products[0],
    });
  } catch (error) {
    return res.status(500).send({
      status: "Error",
      message: "Error",
      error: e.toString(),
    });
  }
});

module.exports = router;
