import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyDqNXwqM6ZPRM1qAgckjdnAzkdkq_i8GfA",
  authDomain: "nutrition-trackerapp.firebaseapp.com",
  projectId: "nutrition-trackerapp",
  storageBucket: "nutrition-trackerapp.firebasestorage.app",
  messagingSenderId: "742555950517",
  appId: "1:742555950517:web:ed82320bb4ecc97b390dfc",
  measurementId: "G-45GN9Q5Z08"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
