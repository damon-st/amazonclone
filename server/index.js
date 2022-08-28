require("dotenv").config();
require("./connection/mongo");
const express = require("express");
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

const PORT = process.env.PORT || 3000;
const app = express();
//middleware
app.use(express.json());

//routes
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

app.listen(PORT, "192.168.1.7", () => {
  console.log(`Listen on Port ${PORT}`);
});
