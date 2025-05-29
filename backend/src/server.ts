import mongoose from 'mongoose';
import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const PORT = process.env.PORT;
const MONGO_URI = process.env.MONGO_URI || '';
console.log(PORT,MONGO_URI)


mongoose
  .connect(MONGO_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB');
    app.listen(PORT, () => {
      console.log(`🚀 Server running at http://localhost:${PORT}`);
    });
  })
  .catch(err => {
    console.log('Mongo URI:', process.env.MONGO_URI);

    console.error('❌ MongoDB connection error:', err, MONGO_URI);
  });
