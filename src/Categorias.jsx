import { useEffect, useState } from 'react'
import './Categorias.css'
import { obtenerCategorias } from './librariaApi'

export default function Categorias({ onVolver, onVerLibros }) {
  const [categorias, setCategorias] = useState([])
  const [cargando, setCargando] = useState(true)

  useEffect(() => {
    let activo = true
    obtenerCategorias()
      .then((data) => { if (activo) setCategorias(data) })
      .catch(console.error)
      .finally(() => { if (activo) setCargando(false) })
    return () => { activo = false }
  }, [])

  if (cargando) {
    return (
      <div className="categorias-page">
        <div className="categorias-cargando">Cargando categorías...</div>
      </div>
    )
  }

  return (
    <div className="categorias-page">
        <div className="categorias-header-texto">
          <p>{categorias.length} categoría{categorias.length !== 1 && 's'} en la biblioteca</p>
        </div>
      <div className="categorias-header">
        
        <div style={{display: 'flex' ,justifyContent: 'right'}}>
        <button type="button" className="categorias-volver" onClick={onVolver}>
          ← Volver al catálogo
        </button>
        </div>
      </div>

      {categorias.length > 0 ? (
        <ul className="categorias-grid">
          {categorias.map((cat) => (
            <li
              key={cat.id}
              className="categorias-item"
              role="button"
              tabIndex={0}
              onClick={() => onVerLibros(cat.slug, cat.nombre)}
              onKeyDown={(e) => { if (e.key === 'Enter') onVerLibros(cat.slug, cat.nombre) }}
            >
              <span className="categorias-nombre">{cat.nombre}</span>
              <span className="categorias-count">{cat.libros} libro{cat.libros !== 1 && 's'}</span>
            </li>
          ))}
        </ul>
      ) : (
        <p className="categorias-vacio">
          No hay categorías registradas. Las categorías aparecen al importar libros.
        </p>
      )}
    </div>
  )
}
