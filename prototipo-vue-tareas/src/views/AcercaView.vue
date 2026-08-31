<template>
  <div class="acerca">
    <h1>Acerca de la Aplicación</h1>

    <div class="card">
      <h2>Technologías Utilizadas</h2>
      <ul class="tech-list">
        <li><strong>Vue.js 3</strong> — Framework frontend progresivo con Composition API</li>
        <li><strong>Pinia</strong> — Gestión de estado global</li>
        <li><strong>Vue Router</strong> — Navegación entre vistas</li>
        <li><strong>Vite</strong> — Herramienta de compilación rápida</li>
      </ul>
    </div>

    <div class="card">
      <h2>Propósito</h2>
      <p>
        Esta aplicación de demostración forma parte del trabajo de investigación
        sobre frameworks frontend. Demuestra la reactividad de Vue.js, la gestión
        de estado con Pinia y el enrutamiento con Vue Router mediante un
        gestor de tareas funcional.
      </p>
    </div>

    <div class="card">
      <h2>Información del Proyecto</h2>
      <table class="info-table">
        <tbody>
          <tr>
            <th>Materia</th>
            <td>Diseño Web II</td>
          </tr>
          <tr>
            <th>Framework seleccionado</th>
            <td>Vue.js 3</td>
          </tr>
          <tr>
            <th>Repositorio</th>
            <td>GitHub</td>
          </tr>
          <tr>
            <th>Integrantes</th>
            <td>[Nombres del grupo]</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.acerca {
  max-width: 700px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.acerca h1 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
}

.card {
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.card h2 {
  color: #2c3e50;
  margin-bottom: 1rem;
  font-size: 1.2rem;
}

.card p {
  color: #555;
  line-height: 1.6;
}

.tech-list {
  list-style: none;
  padding: 0;
}

.tech-list li {
  padding: 0.5rem 0;
  color: #555;
  border-bottom: 1px solid #f0f0f0;
}

.tech-list li:last-child {
  border-bottom: none;
}

.tech-list strong {
  color: #42b883;
}

.info-table {
  width: 100%;
  border-collapse: collapse;
}

.info-table th,
.info-table td {
  padding: 0.6rem;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
}

.info-table th {
  color: #7f8c8d;
  font-weight: 600;
  width: 180px;
}

.info-table td {
  color: #333;
}
</style>
