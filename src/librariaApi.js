const API_URL = '/api'

const PALETA = ['blue-icon', 'red-icon', 'yellow-icon', 'green-icon', 'light-green-icon']
const PLACEHOLDER = '/images/books-media/gird-view/book-media-grid-01.jpg'

function desdeBD(row, i) {
  return {
    id: row.id,
    olWorkKey: row.ol_work_key,
    title: row.titulo,
    author: row.autores || 'Desconocido',
    year: row.anio,
    img: `${API_URL}/libros/${row.id}/portada`,
    fallbackImg: row.portada_url || PLACEHOLDER,
    isbn: row.isbn_13,
    enlace: row.enlace_lectura,
    rating: row.rating ? Number(row.rating) : null,
    votos: row.votos ?? 0,
    categorias: row.categorias ? row.categorias.split(', ') : [],
    color: PALETA[i % PALETA.length],
  }
}

async function pedir(ruta) {
  const res = await fetch(`${API_URL}${ruta}`)
  if (!res.ok) throw new Error(`Error ${res.status} en ${ruta}`)
  return res.json()
}

export async function obtenerLibros({ buscar = '', categoria = '', orden = 'alphabetical', pagina = 1, porPagina = 12 } = {}) {
  const params = new URLSearchParams({ buscar, categoria, orden, pagina, porPagina })
  const json = await pedir(`/libros?${params}`)
  return {
    total: json.total ?? 0,
    libros: json.rows.map(desdeBD),
    fuente: json.fuente ?? 'mysql',
  }
}

export async function obtenerSeccion(slug, limite = 10) {
  const json = await pedir(`/secciones/${slug}?limite=${limite}`)
  return {
    total: json.total ?? 0,
    libros: json.rows.map(desdeBD),
    fuente: json.fuente ?? 'mysql',
  }
}

export async function obtenerCategorias() {
  return pedir('/categorias')
}

export async function obtenerAutores() {
  return pedir('/autores')
}

async function enviar(metodo, ruta, datos = null) {
  const res = await fetch(`${API_URL}${ruta}`, {
    method: metodo,
    headers: datos ? { 'Content-Type': 'application/json' } : undefined,
    body: datos ? JSON.stringify(datos) : undefined,
  })
  if (!res.ok) {
    const error = await res.json().catch(() => ({}))
    throw new Error(error.error || `Error ${res.status} en ${ruta}`)
  }
  return res.status === 204 ? null : res.json()
}

export const crearLibro = (datos) => enviar('POST', '/libros', datos)
export const actualizarLibro = (id, datos) => enviar('PUT', `/libros/${id}`, datos)
export const eliminarLibro = (id) => enviar('DELETE', `/libros/${id}`)
export const crearAutor = (nombre) => enviar('POST', '/autores', { nombre })
export const eliminarAutor = (id) => enviar('DELETE', `/autores/${id}`)
export const crearCategoria = (nombre) => enviar('POST', '/categorias', { nombre })
export const eliminarCategoria = (id) => enviar('DELETE', `/categorias/${id}`)
