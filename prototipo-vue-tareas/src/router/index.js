import { createRouter, createWebHistory } from 'vue-router'
import InicioView from '../views/InicioView.vue'
import TareasView from '../views/TareasView.vue'
import AcercaView from '../views/AcercaView.vue'

const routes = [
  { path: '/', name: 'inicio', component: InicioView },
  { path: '/tareas', name: 'tareas', component: TareasView },
  { path: '/acerca', name: 'acerca', component: AcercaView },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
