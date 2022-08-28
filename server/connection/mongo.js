const mongoose = require("mongoose");

mongoose
  .connect(process.env.URL_MONGO)
  .then(() => {
    console.log("CONNECTION DB SUCCESS");
  })
  .catch((e) => {
    console.log(`CONNECTION DB ERROR ${e}`);
  });

module.exports = mongoose;
