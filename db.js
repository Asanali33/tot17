const { MongoClient } = require("mongodb");

const url = "mongodb://localhost:27017"; // твоя строка
const client = new MongoClient(url);

async function connectDB() {
  try {
    await client.connect();
    console.log("Подключено к MongoDB");

    const db = client.db("mydatabase"); // имя базы
    return db;
  } catch (err) {
    console.error(err);
  }
}

module.exports = connectDB;