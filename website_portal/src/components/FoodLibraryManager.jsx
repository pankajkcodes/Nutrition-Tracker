import React, { useState, useEffect } from 'react';
import { db } from '../firebase/config';
import { collection, getDocs, doc, deleteDoc, setDoc } from 'firebase/firestore';
import { Trash2, Edit2, Plus } from 'lucide-react';

export default function FoodLibraryManager() {
  const [foods, setFoods] = [useState([]), useState][0];
  const [_foods, _setFoods] = useState([]);
  const [loading, setLoading] = useState(true);
  
  // Quick fix for tuple assignment
  const setFoodsState = _setFoods;
  const foodsState = _foods;

  const [isEditing, setIsEditing] = useState(false);
  const [currentFood, setCurrentFood] = useState(null);

  const [formData, setFormData] = useState({
    id: '',
    name: '',
    calories: 0,
    protein: 0,
    carbs: 0,
    fats: 0,
    servingSize: '',
    brand: ''
  });

  const fetchFoods = async () => {
    setLoading(true);
    const querySnapshot = await getDocs(collection(db, 'food_library'));
    const items = [];
    querySnapshot.forEach((doc) => {
      items.push({ id: doc.id, ...doc.data() });
    });
    setFoodsState(items);
    setLoading(false);
  };

  useEffect(() => {
    fetchFoods();
  }, []);

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this item?')) {
      await deleteDoc(doc(db, 'food_library', id));
      fetchFoods();
    }
  };

  const handleEdit = (food) => {
    setCurrentFood(food);
    setFormData(food);
    setIsEditing(true);
  };

  const handleAddNew = () => {
    setCurrentFood(null);
    setFormData({
      id: `food_${Date.now()}`,
      name: '',
      calories: 0,
      protein: 0,
      carbs: 0,
      fats: 0,
      servingSize: '1 serving',
      brand: ''
    });
    setIsEditing(true);
  };

  const handleSave = async (e) => {
    e.preventDefault();
    const docRef = doc(db, 'food_library', formData.id);
    await setDoc(docRef, {
      id: formData.id,
      name: formData.name,
      calories: Number(formData.calories),
      protein: Number(formData.protein),
      carbs: Number(formData.carbs),
      fats: Number(formData.fats),
      servingSize: formData.servingSize,
      brand: formData.brand
    });
    setIsEditing(false);
    fetchFoods();
  };

  if (loading) return <div>Loading...</div>;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-3xl font-bold text-gray-900 dark:text-white">Food Library</h2>
        <button
          onClick={handleAddNew}
          className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors font-medium text-sm"
        >
          <Plus size={16} /> Add New Food
        </button>
      </div>

      {isEditing && (
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700">
          <h3 className="text-xl font-semibold mb-4 dark:text-white">{currentFood ? 'Edit Food' : 'Add New Food'}</h3>
          <form onSubmit={handleSave} className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Name</label>
              <input required type="text" value={formData.name} onChange={e => setFormData({...formData, name: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Brand</label>
              <input type="text" value={formData.brand} onChange={e => setFormData({...formData, brand: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Calories</label>
              <input required type="number" value={formData.calories} onChange={e => setFormData({...formData, calories: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Serving Size</label>
              <input required type="text" value={formData.servingSize} onChange={e => setFormData({...formData, servingSize: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Protein (g)</label>
              <input required type="number" step="0.1" value={formData.protein} onChange={e => setFormData({...formData, protein: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Carbs (g)</label>
              <input required type="number" step="0.1" value={formData.carbs} onChange={e => setFormData({...formData, carbs: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Fats (g)</label>
              <input required type="number" step="0.1" value={formData.fats} onChange={e => setFormData({...formData, fats: e.target.value})} className="w-full px-3 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white" />
            </div>
            
            <div className="md:col-span-2 flex justify-end gap-3 mt-4">
              <button type="button" onClick={() => setIsEditing(false)} className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700">Cancel</button>
              <button type="submit" className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Save Item</button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-xs text-gray-500 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                <th className="px-6 py-3 font-medium">Name</th>
                <th className="px-6 py-3 font-medium">Brand</th>
                <th className="px-6 py-3 font-medium">Serving</th>
                <th className="px-6 py-3 font-medium">Macros (P/C/F)</th>
                <th className="px-6 py-3 font-medium">Cals</th>
                <th className="px-6 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
              {foodsState.map((food) => (
                <tr key={food.id} className="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700/50">
                  <td className="px-6 py-4 font-medium text-gray-900 dark:text-white">{food.name}</td>
                  <td className="px-6 py-4 text-gray-500 dark:text-gray-400">{food.brand || '-'}</td>
                  <td className="px-6 py-4 text-gray-500 dark:text-gray-400">{food.servingSize}</td>
                  <td className="px-6 py-4 text-gray-500 dark:text-gray-400">
                    {food.protein}g / {food.carbs}g / {food.fats}g
                  </td>
                  <td className="px-6 py-4 text-gray-500 dark:text-gray-400">{food.calories}</td>
                  <td className="px-6 py-4 flex justify-end gap-2">
                    <button onClick={() => handleEdit(food)} className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg dark:hover:bg-blue-900/30 transition-colors"><Edit2 size={16} /></button>
                    <button onClick={() => handleDelete(food.id)} className="p-2 text-red-600 hover:bg-red-50 rounded-lg dark:hover:bg-red-900/30 transition-colors"><Trash2 size={16} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {foodsState.length === 0 && (
            <div className="p-8 text-center text-gray-500 dark:text-gray-400">No food items found in library.</div>
          )}
        </div>
      </div>
    </div>
  );
}
