<template>
  <form @submit.prevent="submit" class="tarea-form">
    <input
      v-model="nuevaTarea"
      type="text"
      placeholder="Escribe una nueva tarea..."
      class="input-tarea"
    />
    <button type="submit" class="btn-add" :disabled="!nuevaTarea.trim()">
      Agregar
    </button>
  </form>
</template>

<script setup>
import { ref } from 'vue'
import { useTareasStore } from '../stores/tareas'

const store = useTareasStore()
const nuevaTarea = ref('')

function submit() {
  if (nuevaTarea.value.trim()) {
    store.agregarTarea(nuevaTarea.value.trim())
    nuevaTarea.value = ''
  }
}
</script>

<style scoped>
.tarea-form {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 2rem;
}

.input-tarea {
  flex: 1;
  padding: 0.8rem 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  outline: none;
  transition: border-color 0.3s;
}

.input-tarea:focus {
  border-color: #42b883;
}

.btn-add {
  padding: 0.8rem 1.5rem;
  background-color: #42b883;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s, opacity 0.2s;
}

.btn-add:hover:not(:disabled) {
  background-color: #369970;
}

.btn-add:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
