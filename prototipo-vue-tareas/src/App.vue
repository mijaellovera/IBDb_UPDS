<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header class="app-header">
    <div class="app-title">
      <RouterLink to="/" class="brand">
        <span class="logo">✓</span> Gestor de Tareas
      </RouterLink>
    </div>
    <nav class="nav-links">
      <RouterLink to="/" class="nav-link">Inicio</RouterLink>
      <RouterLink to="/tareas" class="nav-link">Tareas</RouterLink>
      <RouterLink to="/acerca" class="nav-link">Acerca</RouterLink>
    </nav>
  </header>

  <main class="app-main">
    <RouterView />
  </main>

  <footer class="app-footer">
    <p>© 2026 Gestor de Tareas - Vue.js · Diseño Web II · UPDS</p>
  </footer>
</template>

<style scoped>
.app-header {
  background-color: #42b883;
  color: white;
  padding: 1rem 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.app-title a {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  font-size: 1.3rem;
  font-weight: 700;
  color: white;
}

.logo {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  background: white;
  color: #42b883;
  border-radius: 50%;
  font-weight: 900;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
}

.nav-link {
  color: white;
  text-decoration: none;
  padding: 0.4rem 0.8rem;
  border-radius: 6px;
  transition: background-color 0.2s;
  font-weight: 500;
}

.nav-link:hover {
  background-color: rgba(255, 255, 255, 0.2);
}

.nav-link.router-link-exact-active {
  background-color: rgba(255, 255, 255, 0.3);
}

.app-main {
  min-height: calc(100vh - 140px);
}

.app-footer {
  background-color: #f0f0f0;
  padding: 1rem;
  text-align: center;
  color: #999;
  font-size: 0.85rem;
}
</style>
