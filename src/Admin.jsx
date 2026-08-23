import { useEffect, useState } from 'react'
import './Admin.css'
import {
  obtenerLibros,
  obtenerAutores,
  obtenerCategorias,
  crearLibro,
  actualizarLibro,
  eliminarLibro,
  crearAutor,
  eliminarAutor,
  crearCategoria,
  eliminarCategoria,
} from './librariaApi'

const FORM_VACIO = {
  titulo: '',
  anio: '',
  portada_url: '',
  enlace_lectura: '',
  rating_promedio: '',
  autor: '',
  categoria: '',
}

export default function Admin({ volver }) {
  const [pestana, setPestana] = useState('libros')
  const [libros, setLibros] = useState([])
  const [autores, setAutores] = useState([])
  const [categorias, setCategorias] = useState([])
  const [form, setForm] = useState(FORM_VACIO)
  const [editandoId, setEditandoId] = useState(null)
  const [error, setError] = useState('')
  const [autorNombre, setAutorNombre] = useState('')
  const [categoriaNombre, setCategoriaNombre] = useState('')

  async function recargar() {
    try {
      const [l, a, c] = await Promise.all([
        obtenerLibros({ porPagina: 50 }),
        obtenerAutores(),
        obtenerCategorias(),
      ])
      setLibros(l.libros)
      setAutores(a)
      setCategorias(c)
    } catch (e) {
      setError(e.message)
    }
  }

  useEffect(() => {
    recargar()
  }, [])

  async function guardarLibro(e) {
    e.preventDefault()
    setError('')
    const datos = {
      titulo: form.titulo.trim(),
      anio_primer_publicacion: form.anio || null,
      portada_url: form.portada_url || null,
      enlace_lectura: form.enlace_lectura || null,
      rating_promedio: form.rating_promedio || null,
    }
    if (!editandoId) {
      datos.autores = form.autor ? [form.autor.trim()] : []
      datos.categorias = form.categoria ? [form.categoria.trim()] : []
    }
    try {
      if (editandoId) {
        await actualizarLibro(editandoId, datos)
      } else {
        await crearLibro(datos)
      }
      setForm(FORM_VACIO)
      setEditandoId(null)
      await recargar()
    } catch (err) {
      setError(err.message)
    }
  }

  function editarLibro(libro) {
    setEditandoId(libro.id)
    setForm({
      titulo: libro.title ?? '',
      anio: libro.year ?? '',
      portada_url: libro.img ?? '',
      enlace_lectura: libro.enlace ?? '',
      rating_promedio: libro.rating ?? '',
      autor: libro.author ?? '',
      categoria: libro.categorias?.[0] ?? '',
    })
    setPestana('libros')
  }

  async function borrarLibro(id, titulo) {
    if (!window.confirm(`¿Eliminar "${titulo}"?`)) return
    setError('')
    try {
      await eliminarLibro(id)
      if (editandoId === id) {
        setEditandoId(null)
        setForm(FORM_VACIO)
      }
      await recargar()
    } catch (e) {
      setError(e.message)
    }
  }

  async function altaAutor(e) {
    e.preventDefault()
    if (!autorNombre.trim()) return
    setError('')
    try {
      await crearAutor(autorNombre.trim())
      setAutorNombre('')
      await recargar()
    } catch (err) {
      setError(err.message)
    }
  }

  async function bajaAutor(autor) {
    if (!window.confirm(`¿Eliminar al autor "${autor.nombre}"?`)) return
    setError('')
    try {
      await eliminarAutor(autor.id)
      await recargar()
    } catch (e) {
      setError(e.message)
    }
  }

  async function altaCategoria(e) {
    e.preventDefault()
    if (!categoriaNombre.trim()) return
    setError('')
    try {
      await crearCategoria(categoriaNombre.trim())
      setCategoriaNombre('')
      await recargar()
    } catch (err) {
      setError(err.message)
    }
  }

  async function bajaCategoria(categoria) {
    if (!window.confirm(`¿Eliminar la categoría "${categoria.nombre}"?`)) return
    setError('')
    try {
      await eliminarCategoria(categoria.id)
      await recargar()
    } catch (e) {
      setError(e.message)
    }
  }

  return (
    <div className="admin-page">
      <div className="admin-header">
        <h2>Panel de administración</h2>
        <button className="admin-volver" onClick={volver}>← Volver al catálogo</button>
      </div>

      {error && <div className="admin-error">{error}</div>}

      <div className="admin-tabs">
        <button className={pestana === 'libros' ? 'activo' : ''} onClick={() => setPestana('libros')}>Libros ({libros.length})</button>
        <button className={pestana === 'autores' ? 'activo' : ''} onClick={() => setPestana('autores')}>Autores ({autores.length})</button>
        <button className={pestana === 'categorias' ? 'activo' : ''} onClick={() => setPestana('categorias')}>Categorías ({categorias.length})</button>
      </div>

      {pestana === 'libros' && (
        <>
          <form className="admin-form" onSubmit={guardarLibro}>
            <input placeholder="Título *" value={form.titulo} onChange={(e) => setForm({ ...form, titulo: e.target.value })} required />
            <input type="number" placeholder="Año" value={form.anio} onChange={(e) => setForm({ ...form, anio: e.target.value })} />
            <input placeholder="URL de portada" value={form.portada_url} onChange={(e) => setForm({ ...form, portada_url: e.target.value })} />
            <input placeholder="Enlace de lectura" value={form.enlace_lectura} onChange={(e) => setForm({ ...form, enlace_lectura: e.target.value })} />
            <input type="number" step="0.01" min="0" max="5" placeholder="Rating (0-5)" value={form.rating_promedio} onChange={(e) => setForm({ ...form, rating_promedio: e.target.value })} />
            {!editandoId && (
              <>
                <input placeholder="Autor" value={form.autor} onChange={(e) => setForm({ ...form, autor: e.target.value })} />
                <input placeholder="Categoría" value={form.categoria} onChange={(e) => setForm({ ...form, categoria: e.target.value })} />
              </>
            )}
            <div className="admin-acciones">
              <button type="submit">{editandoId ? 'Guardar cambios' : 'Agregar libro'}</button>
              {editandoId && (
                <button type="button" className="secundario" onClick={() => { setEditandoId(null); setForm(FORM_VACIO) }}>
                  Cancelar
                </button>
              )}
            </div>
          </form>

          <table className="admin-tabla">
            <thead>
              <tr>
                <th>ID</th>
                <th>Portada</th>
                <th>Título</th>
                <th>Autor</th>
                <th>Año</th>
                <th>Rating</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {libros.map((libro) => (
                <tr key={libro.id}>
                  <td>{libro.id}</td>
                  <td><img src={libro.img} alt="" /></td>
                  <td>{libro.title}</td>
                  <td>{libro.author}</td>
                  <td>{libro.year ?? '—'}</td>
                  <td>{libro.rating ?? '—'}</td>
                  <td>
                    <button className="admin-editar" onClick={() => editarLibro(libro)}>Editar</button>
                    <button className="admin-borrar" onClick={() => borrarLibro(libro.id, libro.title)}>Eliminar</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}

      {pestana === 'autores' && (
        <>
          <form className="admin-form" onSubmit={altaAutor}>
            <input placeholder="Nombre del autor *" value={autorNombre} onChange={(e) => setAutorNombre(e.target.value)} required />
            <div className="admin-acciones">
              <button type="submit">Agregar autor</button>
            </div>
          </form>
          <ul className="admin-lista">
            {autores.map((autor) => (
              <li key={autor.id}>
                <span>{autor.nombre} — {autor.libros} {autor.libros === 1 ? 'libro' : 'libros'}</span>
                <button className="admin-borrar" onClick={() => bajaAutor(autor)}>Eliminar</button>
              </li>
            ))}
          </ul>
        </>
      )}

      {pestana === 'categorias' && (
        <>
          <form className="admin-form" onSubmit={altaCategoria}>
            <input placeholder="Nombre de la categoría *" value={categoriaNombre} onChange={(e) => setCategoriaNombre(e.target.value)} required />
            <div className="admin-acciones">
              <button type="submit">Agregar categoría</button>
            </div>
          </form>
          <ul className="admin-lista">
            {categorias.map((categoria) => (
              <li key={categoria.id}>
                <span>{categoria.nombre} — {categoria.libros} {categoria.libros === 1 ? 'libro' : 'libros'}</span>
                <button className="admin-borrar" onClick={() => bajaCategoria(categoria)}>Eliminar</button>
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  )
}
