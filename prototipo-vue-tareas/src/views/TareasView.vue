<template>
  <div class="tareas">
    <h1>Gestor de Tareas</h1>

    <div class="stats">
      <div class="stat">
        <span class="stat-number">{{ store.totalTareas }}</span>
        <span class="stat-label">Total</span>
      </div>
      <div class="stat">
        <span class="stat-number">{{ store.tareasPendientes }}</span>
        <span class="stat-label">Pendientes</span>
      </div>
      <div class="stat">
        <span class="stat-number">{{ store.tareasCompletadas }}</span>
        <span class="stat-label">Completadas</span>
      </div>
    </div>

    <TareaForm />
    <TareaLista />
  </div>
</template>

<script setup>
import { useTareasStore } from '../stores/tareas'
import TareaForm from '../components/TareaForm.vue'
import TareaLista from '../components/TareaLista.vue'

const store = useTareasStore()
</script>

<style scoped>
.tareas {
  max-width: 700px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.tareas h1 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
}

.stats {
  display: flex;
  justify-content: center;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat {
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 10px;
  padding: 1rem 1.5rem;
  text-align: center;
  min-width: 100px;
}

.stat-number {
  display: block;
  font-size: 1.8rem;
  font-weight: 700;
  color: #42b883;
}

.stat-label {
  display: block;
  font-size: 0.85rem;
  color: #7f8c8d;
}
</style>
