const lambda = require("./index");
const express = require("express");

const app = express();

app.get("/thumbnail/:b64url", function(req, res) {
  try{
    lambda.handler(
      {
        queryStringParameters: req.query,
        pathParameters: {
          url: req.url.replace("/thumbnail/", "")
        }
      },
      null,
      async function(something, callback) {

        res
          .status(callback.statusCode)
          .header(callback.headers)
          .send(Buffer.from(callback.body, 'base64'))
      }
    )
  } catch (error){
    res.status(400)
  }
});

app.listen(5000, function() {
  console.log("listening on :5000");
});
