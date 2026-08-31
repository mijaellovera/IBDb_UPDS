import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useTareasStore = defineStore('tareas', () => {
  const tareas = ref([])
  let nextId = 1

  const tareasPendientes = computed(() =>
    tareas.value.filter(t => !t.completada).length
  )

  const tareasCompletadas = computed(() =>
    tareas.value.filter(t => t.completada).length
  )

  const totalTareas = computed(() => tareas.value.length)

  function agregarTarea(titulo) {
    tareas.value.push({
      id: nextId++,
      titulo,
      completada: false,
      fecha: new Date().toLocaleDateString('es-BO'),
    })
  }

  function eliminarTarea(id) {
    tareas.value = tareas.value.filter(t => t.id !== id)
  }

  function toggleCompletada(id) {
    const tarea = tareas.value.find(t => t.id === id)
    if (tarea) tarea.completada = !tarea.completada
  }

  function editarTarea(id, nuevoTitulo) {
    const tarea = tareas.value.find(t => t.id === id)
    if (tarea) tarea.titulo = nuevoTitulo
  }

  return {
    tareas,
    tareasPendientes,
    tareasCompletadas,
    totalTareas,
    agregarTarea,
    eliminarTarea,
    toggleCompletada,
    editarTarea,
  }
})
