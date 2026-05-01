import React, { useState, useEffect } from 'react';
import { db } from '../firebase/config';
import { collection, getDocs, doc, deleteDoc, query, orderBy } from 'firebase/firestore';
import { Trash2, User, FileText, ChevronDown, ChevronUp } from 'lucide-react';

export default function UserManager() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [expandedUser, setExpandedUser] = useState(null);
  const [userLogs, setUserLogs] = useState({});
  const [loadingLogs, setLoadingLogs] = useState(false);

  const fetchUsers = async () => {
    setLoading(true);
    const querySnapshot = await getDocs(collection(db, 'users'));
    const items = [];
    querySnapshot.forEach((doc) => {
      items.push({ id: doc.id, ...doc.data() });
    });
    setUsers(items);
    setLoading(false);
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleDeleteUser = async (id) => {
    if (window.confirm('WARNING: Deleting a user profile will not delete their auth record. Are you sure you want to delete their profile data?')) {
      await deleteDoc(doc(db, 'users', id));
      fetchUsers();
    }
  };

  const handleToggleUser = async (userId) => {
    if (expandedUser === userId) {
      setExpandedUser(null);
      return;
    }
    setExpandedUser(userId);
    
    // Fetch logs if not already fetched
    if (!userLogs[userId]) {
      setLoadingLogs(true);
      try {
        const logsRef = collection(db, 'users', userId, 'logs');
        const q = query(logsRef, orderBy('timestamp', 'desc'));
        const querySnapshot = await getDocs(q);
        const logs = [];
        querySnapshot.forEach((doc) => {
          logs.push({ id: doc.id, ...doc.data() });
        });
        setUserLogs(prev => ({ ...prev, [userId]: logs }));
      } catch (err) {
        console.error("Error fetching logs", err);
      }
      setLoadingLogs(false);
    }
  };

  const handleDeleteLog = async (userId, logId) => {
    if (window.confirm('Delete this food entry?')) {
      await deleteDoc(doc(db, 'users', userId, 'logs', logId));
      setUserLogs(prev => ({
        ...prev,
        [userId]: prev[userId].filter(log => log.id !== logId)
      }));
    }
  };

  if (loading) return <div>Loading users...</div>;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-3xl font-bold text-gray-900 dark:text-white">Users</h2>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-xs text-gray-500 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                <th className="px-6 py-3 font-medium">User Details</th>
                <th className="px-6 py-3 font-medium">Joined</th>
                <th className="px-6 py-3 font-medium">Goals (Cals/Water)</th>
                <th className="px-6 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
              {users.map((user) => (
                <React.Fragment key={user.id}>
                  <tr className="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700/50">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-blue-100 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400 flex items-center justify-center">
                          <User size={20} />
                        </div>
                        <div>
                          <div className="font-medium text-gray-900 dark:text-white">{user.fullName || 'Anonymous'}</div>
                          <div className="text-xs text-gray-500 dark:text-gray-400">{user.email || 'No email provided'} (ID: {user.uid})</div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-gray-500 dark:text-gray-400">
                      {user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'Unknown'}
                    </td>
                    <td className="px-6 py-4 text-gray-500 dark:text-gray-400">
                      {user.dailyCalorieGoal || 0} kcal / {user.dailyWaterGoalLiters || 0} L
                    </td>
                    <td className="px-6 py-4 flex justify-end gap-2">
                      <button 
                        onClick={() => handleToggleUser(user.id)} 
                        className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg dark:hover:bg-blue-900/30 transition-colors flex items-center gap-1"
                      >
                        <FileText size={16} /> Logs {expandedUser === user.id ? <ChevronUp size={16}/> : <ChevronDown size={16}/>}
                      </button>
                      <button onClick={() => handleDeleteUser(user.id)} className="p-2 text-red-600 hover:bg-red-50 rounded-lg dark:hover:bg-red-900/30 transition-colors">
                        <Trash2 size={16} />
                      </button>
                    </td>
                  </tr>
                  
                  {/* Expanded Logs Section */}
                  {expandedUser === user.id && (
                    <tr className="bg-gray-50/50 dark:bg-gray-900/30 border-t border-gray-100 dark:border-gray-800">
                      <td colSpan="4" className="px-6 py-4">
                        <h4 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3">User Food Logs</h4>
                        {loadingLogs ? (
                          <div className="text-sm text-gray-500">Loading logs...</div>
                        ) : userLogs[user.id]?.length > 0 ? (
                          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                            {userLogs[user.id].map(log => (
                              <div key={log.id} className="bg-white dark:bg-gray-800 p-3 rounded-lg border border-gray-200 dark:border-gray-700 flex justify-between items-start">
                                <div>
                                  <div className="font-medium text-gray-900 dark:text-white text-sm">{log.foodItem?.name}</div>
                                  <div className="text-xs text-gray-500 mt-1">
                                    {new Date(log.timestamp).toLocaleString()} • {log.mealType}
                                  </div>
                                  <div className="text-xs text-blue-600 dark:text-blue-400 mt-1">
                                    {log.totalCalories?.toFixed(0)} kcal ({log.amountServed}x serving)
                                  </div>
                                </div>
                                <button onClick={() => handleDeleteLog(user.id, log.id)} className="text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 p-1 rounded">
                                  <Trash2 size={14} />
                                </button>
                              </div>
                            ))}
                          </div>
                        ) : (
                          <div className="text-sm text-gray-500">No food logs found for this user.</div>
                        )}
                      </td>
                    </tr>
                  )}
                </React.Fragment>
              ))}
            </tbody>
          </table>
          {users.length === 0 && (
            <div className="p-8 text-center text-gray-500 dark:text-gray-400">No users found.</div>
          )}
        </div>
      </div>
    </div>
  );
}
