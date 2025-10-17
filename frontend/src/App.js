import React, { useState, useEffect } from "react";
import { getExpenses, createExpense, updateExpense, deleteExpense } from "./api";
import ExpenseList from "./components/ExpenseList";
import ExpenseForm from "./components/ExpenseForm";
import "bootstrap/dist/css/bootstrap.min.css";

function App() {
  const [expenses, setExpenses] = useState([]);
  const [editingExpense, setEditingExpense] = useState(null);

  const fetchExpenses = async () => {
    try {
      const res = await getExpenses();
      setExpenses(res.data);
    } catch (err) {
      console.error("Error fetching expenses:", err);
    }
  };

  useEffect(() => {
    fetchExpenses();
  }, []);

  const handleCreate = async (data) => {
    try {
      await createExpense(data);
      fetchExpenses();
    } catch (err) {
      console.error("Error creating expense:", err);
    }
  };

  const handleUpdate = async (id, data) => {
    try {
      await updateExpense(id, data);
      fetchExpenses();
      setEditingExpense(null);
    } catch (err) {
      console.error("Error updating expense:", err);
    }
  };

  const handleDelete = async (id) => {
    try {
      await deleteExpense(id);
      fetchExpenses();
    } catch (err) {
      console.error("Error deleting expense:", err);
    }
  };

  return (
    <div className="container mt-4">
      <h1 className="mb-4">Expense Tracker</h1>
      <ExpenseForm onSubmit={editingExpense ? handleUpdate : handleCreate} editingExpense={editingExpense} />
      <ExpenseList expenses={expenses} onEdit={setEditingExpense} onDelete={handleDelete} />
    </div>
  );
}

export default App;
