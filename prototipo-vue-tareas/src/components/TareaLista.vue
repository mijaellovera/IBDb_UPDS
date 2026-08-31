<template>
  <div class="tarea-lista">
    <transition-group v-if="store.tareas.length > 0" name="list" tag="ul" class="list">
      <TareaItem
        v-for="tarea in store.tareas"
        :key="tarea.id"
        :tarea="tarea"
      />
    </transition-group>

    <div v-else class="vacio">
      <p class="icono">📋</p>
      <p class="texto">No hay tareas todavía. ¡Agrega tu primera tarea!</p>
    </div>
  </div>
</template>

<script setup>
import { useTareasStore } from '../stores/tareas'
import TareaItem from './TareaItem.vue'

const store = useTareasStore()
</script>

<style scoped>
.list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.vacio {
  text-align: center;
  padding: 3rem 1rem;
  background: white;
  border: 2px dashed #ddd;
  border-radius: 12px;
}

.icono {
  font-size: 3rem;
  margin-bottom: 0.5rem;
}

.texto {
  color: #777;
  font-size: 1rem;
}

.list-enter-active,
.list-leave-active {
  transition: all 0.4s ease;
}

.list-enter-from {
  opacity: 0;
  transform: translateY(-20px);
}

.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

.list-leave-active {
  position: absolute;
  width: 100%;
}
</style>
