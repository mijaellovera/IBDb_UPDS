import { useEffect, useState } from 'react'
import './Autores.css'
import { obtenerAutores } from './librariaApi'

function agruparPorLetra(autores) {
  const grupos = {}

  autores.forEach((autor) => {
    const primera = autor.nombre?.trim().charAt(0).toUpperCase() || '#'
    const letra = /^[A-Z]$/.test(primera) ? primera : '#'
    if (!grupos[letra]) grupos[letra] = []
    grupos[letra].push(autor)
  })

  return Object.keys(grupos)
    .sort((a, b) => {
      if (a === '#') return 1
      if (b === '#') return -1
      return a.localeCompare(b)
    })
    .map((letra) => ({ letra, items: grupos[letra] }))
}

function FotoAutor({ src, nombre }) {
  const fallback = '/images/books-media/gird-view/book-media-grid-01.jpg'
  return (
    <img
      src={src || fallback}
      alt={nombre}
      onError={(e) => { e.target.src = fallback }}
    />
  )
}

export default function Autores({ onVolver, onVerObras }) {
  const [autores, setAutores] = useState([])
  const [cargando, setCargando] = useState(true)

  useEffect(() => {
    let activo = true
    obtenerAutores()
      .then((data) => { if (activo) setAutores(data) })
      .catch(console.error)
      .finally(() => { if (activo) setCargando(false) })
    return () => { activo = false }
  }, [])

  const grupos = agruparPorLetra(autores)
  const letrasDisponibles = grupos.map((g) => g.letra)

  if (cargando) {
    return (
      <div className="autores-page">
        <div className="autores-cargando">Cargando autores...</div>
      </div>
    )
  }

  return (
    <div className="autores-page">
        <div className="autores-header-texto">
          <p>{autores.length} autor{autores.length !== 1 && 'es'} en la biblioteca</p>
        </div>
        <div className="autores-header">
        
        <div style={{display: 'flex' ,justifyContent: 'right'}}>
        <button type="button" className="autores-volver" onClick={onVolver}>
          ← Volver al catálogo
        </button>
        </div>
      </div>

      {letrasDisponibles.length > 0 && (
        <nav className="autores-alfabeto">
          {letrasDisponibles.map((l) => (
            <a key={l} href={`#letra-${l}`}>{l}</a>
          ))}
        </nav>
      )}

      {grupos.map(({ letra, items }) => (
        <section key={letra} id={`letra-${letra}`} className="autores-grupo">
          <div className="autores-letra-separador">{letra}</div>
          <ul className="autores-lista">
            {items.map((autor) => (
              <li key={autor.id} className="autores-item">
                <div className="autores-foto">
                  <FotoAutor src={autor.foto_url} nombre={autor.nombre} />
                </div>
                <div className="autores-info">
                  <strong
                    className="autores-nombre"
                    role="button"
                    tabIndex={0}
                    style={{ cursor: 'pointer', textDecoration: 'underline', textDecorationStyle: 'dotted', textUnderlineOffset: '3px' }}
                    onClick={() => onVerObras(autor.nombre)}
                    onKeyDown={(e) => { if (e.key === 'Enter') onVerObras(autor.nombre) }}
                  >
                    {autor.nombre}
                  </strong>
                  <span className="autores-meta">
                    {autor.libros} libro{autor.libros !== 1 && 's'}
                    {autor.obra_principal && ` · ${autor.obra_principal}`}
                  </span>
                </div>
              </li>
            ))}
          </ul>
        </section>
      ))}

      {autores.length === 0 && (
        <p className="autores-vacio">
          No hay autores registrados. Los autores aparecen al importar libros o al crear
          libros desde el panel de administración.
        </p>
      )}
    </div>
  )
}
