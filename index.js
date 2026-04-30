const connectDB = require("./db");

async function run() {
  const db = await connectDB();

  const users = db.collection("users");

  const data = await users.find().toArray();
  console.log(data);
}

run();