<template>
  <div class="inicio">
    <div class="hero">
      <h1>Gestor de Tareas</h1>
      <p class="subtitle">
        Aplicación desarrollada con Vue.js 3, Pinia y Vue Router
      </p>
      <p class="description">
        Organiza tus tareas de forma sencilla y eficiente. Crea, edita,
        marca como completadas y elimina tareas con una interfaz moderna
        y reactiva.
      </p>
      <router-link to="/tareas" class="btn-primary">
        Comenzar
      </router-link>
    </div>

    <div class="features">
      <div class="feature-card">
        <div class="feature-icon">📝</div>
        <h3>Crear Tareas</h3>
        <p>Agrega nuevas tareas rápidamente con el formulario intuitivo.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">✅</div>
        <h3>Marcar Completadas</h3>
        <p>Marca tus tareas como completadas con un solo clic.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">🗑️</div>
        <h3>Eliminar Tareas</h3>
        <p>Elimina las tareas que ya no necesitas.</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.inicio {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.hero {
  text-align: center;
  padding: 3rem 1rem;
  margin-bottom: 3rem;
}

.hero h1 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.subtitle {
  font-size: 1.1rem;
  color: #7f8c8d;
  margin-bottom: 1rem;
}

.description {
  font-size: 1rem;
  color: #555;
  max-width: 600px;
  margin: 0 auto 2rem;
  line-height: 1.6;
}

.btn-primary {
  display: inline-block;
  padding: 0.8rem 2rem;
  background-color: #42b883;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 600;
  transition: background-color 0.3s, transform 0.2s;
}

.btn-primary:hover {
  background-color: #369970;
  transform: translateY(-2px);
}

.features {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.5rem;
}

.feature-card {
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  padding: 1.5rem;
  text-align: center;
  transition: box-shadow 0.3s, transform 0.2s;
}

.feature-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-3px);
}

.feature-icon {
  font-size: 2rem;
  margin-bottom: 0.8rem;
}

.feature-card h3 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.feature-card p {
  color: #777;
  font-size: 0.9rem;
}
</style>
