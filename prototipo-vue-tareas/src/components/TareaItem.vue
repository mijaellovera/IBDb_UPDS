<template>
  <li class="tarea-item" :class="{ completada: tarea.completada, editando }">
    <div class="tarea-content">
      <label class="checkbox">
        <input
          type="checkbox"
          :checked="tarea.completada"
          @change="store.toggleCompletada(tarea.id)"
        />
        <span class="checkmark"></span>
      </label>

      <div class="tarea-texto">
        <template v-if="editando">
          <input
            v-model="tituloEdit"
            class="input-editar"
            @keyup.enter="guardarEdicion"
            @keyup.esc="cancelarEdicion"
          />
        </template>
        <template v-else>
          <p class="titulo">{{ tarea.titulo }}</p>
          <p class="fecha">Agregada: {{ tarea.fecha }}</p>
        </template>
      </div>
    </div>

    <div class="tarea-acciones">
      <template v-if="editando">
        <button class="btn-icon btn-save" title="Guardar" @click="guardarEdicion">💾</button>
        <button class="btn-icon btn-cancel" title="Cancelar" @click="cancelarEdicion">✖</button>
      </template>
      <template v-else>
        <button class="btn-icon btn-edit" title="Editar" @click="iniciarEdicion">✏️</button>
        <button class="btn-icon btn-delete" title="Eliminar" @click="store.eliminarTarea(tarea.id)">🗑️</button>
      </template>
    </div>
  </li>
</template>

<script setup>
import { ref } from 'vue'
import { useTareasStore } from '../stores/tareas'

const props = defineProps({
  tarea: {
    type: Object,
    required: true,
  },
})

const store = useTareasStore()
const editando = ref(false)
const tituloEdit = ref('')

function iniciarEdicion() {
  tituloEdit.value = props.tarea.titulo
  editando.value = true
}

function guardarEdicion() {
  if (tituloEdit.value.trim()) {
    store.editarTarea(props.tarea.id, tituloEdit.value.trim())
  }
  editando.value = false
}

function cancelarEdicion() {
  editando.value = false
}
</script>

<style scoped>
.tarea-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 10px;
  padding: 1rem;
  margin-bottom: 0.75rem;
  transition: box-shadow 0.3s, opacity 0.3s;
}

.tarea-item:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.tarea-item.completada {
  background: #f9f9f9;
  opacity: 0.7;
}

.tarea-item.completada .titulo {
  text-decoration: line-through;
  color: #999;
}

.tarea-item.editando {
  border-color: #42b883;
}

.tarea-content {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}

.checkbox {
  position: relative;
  cursor: pointer;
  flex-shrink: 0;
}

.checkbox input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  width: 20px;
  height: 20px;
}

.checkmark {
  height: 22px;
  width: 22px;
  background-color: #fff;
  border: 2px solid #ddd;
  border-radius: 4px;
  display: inline-block;
  transition: background-color 0.3s, border-color 0.3s;
}

.checkbox input:checked + .checkmark {
  background-color: #42b883;
  border-color: #42b883;
}

.checkbox input:checked + .checkmark::after {
  content: '✓';
  color: white;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.tarea-texto {
  flex: 1;
}

.titulo {
  font-size: 1rem;
  color: #333;
  word-break: break-word;
}

.fecha {
  font-size: 0.8rem;
  color: #999;
  margin-top: 0.2rem;
}

.input-editar {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #42b883;
  border-radius: 6px;
  font-size: 1rem;
  outline: none;
}

.tarea-acciones {
  display: flex;
  gap: 0.4rem;
  flex-shrink: 0;
}

.btn-icon {
  background: none;
  border: none;
  font-size: 1.1rem;
  cursor: pointer;
  padding: 0.3rem;
  border-radius: 6px;
  transition: background-color 0.2s;
}

.btn-icon:hover {
  background-color: #f0f0f0;
}

.btn-delete:hover {
  background-color: #fde8e8;
}

.btn-save:hover {
  background-color: #e8f8f0;
}
</style>
