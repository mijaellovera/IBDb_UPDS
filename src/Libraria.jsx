import { useEffect, useState } from 'react'
import './Libraria.css'
import { obtenerLibros, obtenerSeccion } from './librariaApi'
import Admin from './Admin'
import Autores from './Autores'
import Categorias from './Categorias'

const navLinks = [
  { label: 'Home', vista: 'catalogo' },
  { label: 'Autores', vista: 'autores' },
  { label: 'Categorias', vista: 'categorias' },
  { label: 'Novedades', vista: 'novedades' },
  { label: 'Destacados', vista: 'destacados' },
]

function Header({ buscar, onBuscar, onAdmin, onNav, vistaActual }) {
    const [texto, setTexto] = useState(buscar)
    const [menuAbierto, setMenuAbierto] = useState(false)

    const manejarBusqueda = (e) => {
        e.preventDefault()

        const termino = texto.trim()

        if (termino) {
            onBuscar(termino)
        }
    }

    return (
    <header className="header">
        <div className="header-contenedor">

            <div className="header-superior">

                <a href="/" className="logo">
                    <img
                      src="/images/logo.png"
                      alt="IBDb UPDS"
                      className="logo-imagen"
                    />
                    <div>
                        <strong>IBDb UPDS</strong>
                        <p>Biblioteca Digital</p>
                    </div>
                </a>

                <button
                    type="button"
                    className="admin"
                    onClick={onAdmin}
                >
                    ADMIN
                </button>

           {/* BOTÓN HAMBURGUESA - SOLO MÓVIL */}
                <button
                  type="button"
                  className="menu-hamburguesa"
                  onClick={() => setMenuAbierto(!menuAbierto)}
                  aria-label={menuAbierto ? 'Cerrar menú' : 'Abrir menú'}
                  aria-expanded={menuAbierto}
                >
                  {menuAbierto ? '×' : '☰'}
                </button>

            </div>

            <div className="header-inferior">

                <nav className="menu">
                    {navLinks.map((link) => (
                        <a
                            key={link.label}
                            href="#"
                            className={vistaActual === link.vista ? 'active' : ''}
                            onClick={(e) => { e.preventDefault(); onNav(link.vista) }}
                        >
                            {link.label}
                        </a>
                    ))}
                </nav>
             
                        {/* MENÚ DESPLEGABLE MÓVIL */}
                <div
                  className={`menu-mobile-panel ${
                  menuAbierto ? 'abierto' : ''
                  }`}
                >
                  {navLinks.map((link) => (
                  <a
                    key={link.label}
                    href="#"
                    className={vistaActual === link.vista ? 'active' : ''}
                    onClick={(e) => {
                      e.preventDefault()
                      onNav(link.vista)
                      setMenuAbierto(false)
                      }}
                  >
                  {link.label}
                </a>
              ))}
            </div>

                <form
                    className="buscador"
                    onSubmit={manejarBusqueda}
                >
                    <input
                        type="search"
                        placeholder="Buscar por título o autor..."
                        value={texto}
                        onChange={(e) => setTexto(e.target.value)}
                    />

                    <button type="submit">
                        BUSCAR
                    </button>
                </form>

            </div>

        </div>
    </header>
  )
}

function GridBookItem({ book, onDetalle }) {
  return (
    <li className="book-grid-item">
      <figure className="book-card">

        <div className="book-cover">
          <img
            src={book.img}
            alt={book.title}
            onClick={() => onDetalle(book)}
            onError={(e) => { e.target.onerror = null; e.target.src = book.fallbackImg }}
          />

          <div className="book-overlay">
            <h3 className="book-title">
              {book.title}
            </h3>

            <p className="book-author">
              <strong>Autor:</strong> {book.author}
            </p>

            {book.isbn && (
              <p>
                <strong>ISBN:</strong> {book.isbn}
              </p>
            )}

            {book.year && (
              <p>
                <strong>Año:</strong> {book.year}
              </p>
            )}

            {book.rating && (
              <p>
                <strong>Rating:</strong> {book.rating} / 5
                {book.votos ? ` (${book.votos} votos)` : ''}
              </p>
            )}

            <p className="book-categorias">
              <strong>Categorías:</strong>{" "}
              {book.categorias?.length
                ? book.categorias.join(", ")
                : "Clásico disponible para lectura online."}
            </p>

            <button
              type="button"
              className="btn-ver-detalle"
              onClick={(e) => {
                e.stopPropagation()
                onDetalle(book)
              }}
            >
              VER DETALLE
            </button>
          </div>
        </div>

      </figure>
    </li>
  )
}
function FullWidthBookItem({ book, onDetalle}) {
  return (
    <li>
      <div className={`book-list-icon ${book.color}`}></div>
      <figure>
        <a href="#"><img src={book.img} alt={book.title} onClick={() => onDetalle(book)} 
        style={{ cursor: 'pointer' }} onError={(e) => { e.target.onerror = null; e.target.src = book.fallbackImg }}/></a>
        <figcaption>
          <header>
            <h4><a href="#">{book.title}</a></h4>
            <p><strong>Author:</strong> {book.author}</p>
            {book.isbn && <p><strong>ISBN:</strong> {book.isbn}</p>}
            <p><strong>Rating:</strong> {book.rating ? `${book.rating} / 5` : 'Sin valorar'} ({book.votos})</p>
          </header>
          <p>{book.categorias?.length ? `Categorías: ${book.categorias.join(', ')}` : ''}</p>
          <div className="actions">
            <ul>
              <li><a href="#"><i className="fa fa-heart"></i></a></li>
              <li><a href="#"><i className="fa fa-envelope"></i></a></li>
              <li><a href={book.enlace || '#'} target="_blank" rel="noreferrer"><i className="fa fa-book"></i></a></li>
              <li><a href="#"><i className="fa fa-share-alt"></i></a></li>
            </ul>
          </div>
        </figcaption>
      </figure>
    </li>
  )
}

function SeccionLibros({ slug, titulo, descripcion, onVolver, onDetalle }) {
  const [libros, setLibros] = useState([])
  const [cargando, setCargando] = useState(true)

  useEffect(() => {
    let activo = true
    obtenerSeccion(slug, 12)
      .then(({ libros }) => {
        if (!activo) return
        setLibros(libros)
      })
      .catch(console.error)
      .finally(() => activo && setCargando(false))
    return () => { activo = false }
  }, [slug])

  return (
    <div className="seccion-page">
      <div className="seccion-header">
        <div className="seccion-header-texto">
          {descripcion && <p>{descripcion}</p>}
        </div>
      </div>
      <div style={{display: 'flex' ,justifyContent: 'right'}}>
        <button type="button" className="seccion-volver" onClick={onVolver}>
          ← Volver al catálogo
        </button>
      </div>

      {cargando && <p className="seccion-cargando">Cargando libros...</p>}

      {!cargando && libros.length === 0 && (
        <p className="seccion-vacio">No hay libros en esta sección.</p>
      )}


      {!cargando && libros.length > 0 && (
        <div className="books-gird">
          <ul>
            {libros.map((book) => (
              <GridBookItem key={book.id} book={book} onDetalle={onDetalle} />
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

function BookDetail({ book, onVolver, etiquetaVolver = 'Volver al catálogo' }) {
    if (!book) return null

    return (
        <section className="detalle-libro">
            <div className="container">

                {/* BOTÓN PARA VOLVER */}
                <button
                    type="button"
                    className="detalle-volver"
                    onClick={onVolver}
                >
                    ← {etiquetaVolver}
                </button>

                <div className="detalle-contenido">

                    {/* =========================
                        INFORMACIÓN - IZQUIERDA
                    ========================== */}
                    <div className="detalle-informacion">

                        <span className="detalle-etiqueta">
                            DETALLE DEL LIBRO
                        </span>

                        <h2>{book.title}</h2>

                        <p className="detalle-autor">
                            {book.author || 'Autor desconocido'}
                        </p>

                        {/* DATOS DEL LIBRO */}
                        <div className="detalle-datos">

                            <p>
                                <strong>Autor:</strong>{' '}
                                {book.author || 'No disponible'}
                            </p>

                            <p>
                                <strong>Año de publicación:</strong>{' '}
                                {book.year || 'No disponible'}
                            </p>

                            <p>
                                <strong>ISBN:</strong>{' '}
                                {book.isbn || 'No disponible'}
                            </p>

                            <p>
                                <strong>Rating:</strong>{' '}
                                {book.rating
                                    ? `${book.rating} / 5`
                                    : 'Sin valoración'}
                            </p>

                            <p>
                                <strong>Votos:</strong>{' '}
                                {book.votos || 0}
                            </p>

                            <p>
                                <strong>Categorías:</strong>{' '}
                                {book.categorias?.length
                                    ? book.categorias.join(', ')
                                    : 'No disponible'}
                            </p>

                        </div>

                        {/* =========================
                            SINOPSIS
                        ========================== */}
                        <div className="detalle-descripcion">

                            <h3>Sinopsis</h3>

                            <p>
                                {book.descripcion ||
                                    'No hay una sinopsis disponible para este libro.'}
                            </p>

                        </div>

                        {/* =========================
                            BOTÓN DE LECTURA
                        ========================== */}
                        {book.enlace && (
                            <a
                                href={book.enlace}
                                target="_blank"
                                rel="noreferrer"
                                className="detalle-leer"
                            >
                            </a>
                        )}

                    </div>

                    {/* =========================
                        PORTADA - DERECHA
                    ========================== */}
                    <div className="detalle-portada">

                        <img
                            src={book.img}
                            alt={book.title}
                            onError={(e) => {
                                e.target.onerror = null
                                e.target.src = book.fallbackImg
                            }}
                        />

                    </div>

                </div>

            </div>
        </section>
    )
}

function Footer() {
  return (
    <footer className="site-footer">
      <div className="container">
        <div className="footer-simple">
          <div className="row">
            <div className="col-md-3 col-sm-6">
              <div className="footer-logo">
                <img alt="IBDb UPDS" class="logo-imagen" src="/images/logo.png"></img>
              </div>
            </div>
            <div className="col-md-6 col-sm-6">
              <div className="footer-about">
                <h3>Acerca de Nosotros</h3>
                <p>Somos una biblioteca dedicada a la difusion del conocimiento y la cultura, ofreciendo a nuestra comunidad un espacio de acceso libre a la informacion y la lectura.</p>
              </div>
            </div>
            <div className="col-md-3 col-sm-12">
              
                <div className="footer-contacto">

        <h3>Contacto</h3>

        <p>☎ +591 00000000</p>

        <p>✉ support@IBDbUPDS.com</p>

    </div>
              <div className="footer-social">
                <span className="social-icon"><i className="fab fa-facebook"></i></span>
                <span className="social-icon"><i className="fab fa-twitter"></i></span>
                <span className="social-icon"><i className="fab fa-instagram"></i></span>
                <span className="social-icon"><i className="fab fa-youtube"></i></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}

export default function Libraria() {
  const [view] = useState('grid')
  const [libros, setLibros] = useState([])
  const [total, setTotal] = useState(0)
  const [orden, setOrden] = useState('alphabetical')
  const [buscar, setBuscar] = useState('')
  const [pagina, setPagina] = useState(1)
  const [libroSeleccionado, setLibroSeleccionado] = useState(null)
  const [cargando, setCargando] = useState(true)
  const [vista, setVista] = useState('catalogo')
  const [categoria, setCategoria] = useState('')
  const [fuente, setFuente] = useState('mysql')
  const porPagina = view === 'grid' ? 12 : 9
  const totalPaginas = Math.max(1, Math.ceil(total / porPagina))

  useEffect(() => {
    let activo = true
    setCargando(true)
    obtenerLibros({ buscar, categoria, orden, pagina, porPagina })
      .then(({ total, libros, fuente }) => {
        if (!activo) return
        setLibros(libros)
        setTotal(total)
        setFuente(fuente)
      })
      .catch(console.error)
      .finally(() => activo && setCargando(false))
    return () => { activo = false }
  }, [buscar, categoria, orden, pagina, porPagina])

  return (
    <div>
      <Header
        buscar={buscar}
        vistaActual={vista}
        onBuscar={(t) => { setBuscar(t); setCategoria(''); setPagina(1) }}
        onAdmin={() => setVista('admin')}
        onNav={(v) => { setVista(v); if (v === 'catalogo') { setBuscar(''); setCategoria(''); setPagina(1) } }}
      />

      {vista === 'admin' && <Admin volver={() => setVista('catalogo')} />}
      {vista === 'autores' && (
        <Autores
          onVolver={() => setVista('catalogo')}
          onVerObras={(nombre) => { setBuscar(nombre); setPagina(1); setVista('catalogo') }}
        />
      )}
      {vista === 'categorias' && (
        <Categorias
          onVolver={() => setVista('catalogo')}
          onVerLibros={(slug) => { setCategoria(slug); setPagina(1); setVista('catalogo') }}
        />
      )}

      {vista === 'destacados' && !libroSeleccionado && (
        <SeccionLibros
          slug="destacados"
          titulo="Destacados"
          descripcion="Libros seleccionados por el equipo y los mejor valorados de la biblioteca"
          onVolver={() => setVista('catalogo')}
          onDetalle={setLibroSeleccionado}
        />
      )}

      {vista === 'novedades' && !libroSeleccionado && (
        <SeccionLibros
          slug="novedades"
          titulo="Novedades"
          descripcion="Libros publicados más recientemente en la biblioteca"
          onVolver={() => setVista('catalogo')}
          onDetalle={setLibroSeleccionado}
        />
      )}

      {libroSeleccionado ? (

    <BookDetail
      book={libroSeleccionado}
      onVolver={() => setLibroSeleccionado(null)}
      etiquetaVolver={
        vista === 'destacados' ? 'Volver a Destacados'
        : vista === 'novedades' ? 'Volver a Novedades'
        : 'Volver al catálogo'
      }
    />

  ) : vista === 'catalogo' && (
    <>
      <section className="page-banner services-banner">
        <div className="container">
          <div className="banner-header">
            <h2>Books &amp; Media Listing</h2>
            <span className="underline center"></span>
            <p className="lead">Catálogo de libros con datos de Open Library</p>
          </div>
          <div className="breadcrumb">
            <ul>
              <li><a href="#">Home</a></li>
              <li>Books &amp; Media</li>
            </ul>
          </div>
        </div>
      </section>

      <div id="content" className="site-content">
        <div id="primary" className="content-area">
          <main id="main" className="site-main">
            <div className={view === 'grid' ? 'books-media-gird' : 'books-full-width'}>
              <div className="container">
                <div className="row">
                  <div className="col-md-12">
                    {(buscar || categoria) && (
                      <div style={{ marginBottom: 12, display: 'flex', alignItems: 'center', gap: 10 }}>
                        <span style={{ fontSize: 14, color: '#555' }}>
                          {buscar && <>Libros de: <strong>{buscar}</strong></>}
                          {categoria && <>Categoría: <strong>{categoria.replace(/-/g, ' ')}</strong></>}
                        </span>
                        <button
                          type="button"
                          style={{ padding: '4px 12px', border: '1px solid #ccc', background: '#fff', cursor: 'pointer', borderRadius: 4, fontSize: 13 }}
                          onClick={() => { setBuscar(''); setCategoria(''); setPagina(1) }}
                        >
                          ← Ver todos los libros
                        </button>
                      </div>
                    )}
                    <div className="filter-options margin-list">
                      <div className="row" style={{margin: "25px"}}>
                        <div className="col-md-4 col-sm-4">
                          <select name="orderby" value={orden} onChange={(e) => { setOrden(e.target.value); setPagina(1) }}>
                            <option value="alphabetical">Sort alphabetically</option>
                            <option value="default">Default sorting</option>
                            <option value="popularity">Sort by popularity</option>
                            <option value="rating">Sort by rating</option>
                            <option value="newness">Sort by newness</option>
                          </select>
                        </div>
                        <div className="col-md-4 col-sm-4">
                          <div className="filter-result">
                            Mostrando {libros.length} de {total} resultados
                            {fuente === 'openlibrary' && (
                              <em style={{ color: '#2e7d32', marginLeft: 8 }}>nuevos desde Open Library</em>
                            )}
                          </div>
                        </div>
                        <div className="col-md-3 col-sm-3 pull-right">
                      </div> 
                      </div>
                    </div>

                    {cargando && <p>{buscar ? 'Consultando Open Library...' : 'Cargando libros...'}</p>}

                    {!cargando && total === 0 && (
                      <p>
                        {buscar
                          ? `Sin resultados para "${buscar}" en la biblioteca.`
                          : 'La biblioteca está vacía. Usa el buscador para traer libros desde Open Library.'}
                      </p>
                    )}

                    {!cargando && view === 'grid' ? (
                      <div className="books-gird">
                        <ul>
                          {libros.map((book) => (
                            <GridBookItem key={book.id} book={book} onDetalle={setLibroSeleccionado} />
                          ))}
                        </ul>
                      </div>
                    ) : !cargando && (
                      <div className="booksmedia-fullwidth">
                        <ul>
                          {libros.map((book) => (
                            <FullWidthBookItem key={book.id} book={book} />
                          ))}
                        </ul>
                      </div>
                    )}

                    {total > 0 && (
                      <nav className="navigation pagination text-center">
                        <h2 className="screen-reader-text">Posts navigation</h2>
                        <div className="nav-links">
                          {pagina > 1 && (
                           <a
                              className="prev page-numbers"
                              href="#"
                              onClick={(e) => {
                                e.preventDefault()
                                setPagina(pagina - 1)
                              }}
                            >
                              <span className="pagination-arrow">←</span> Previous
                            </a>
                          )}
                          {Array.from({ length: totalPaginas }, (_, i) => i + 1).map((n) =>
                            n === pagina ? (
                              <span key={n} className="page-numbers current">{n}</span>
                            ) : (
                              <a key={n} className="page-numbers" href="#" onClick={(e) => { e.preventDefault(); setPagina(n) }}>
                                {n}
                              </a>
                            )
                          )}
                          {pagina < totalPaginas && (
                            <a
                              className="next page-numbers"
                              href="#"
                              onClick={(e) => {
                                e.preventDefault()
                                setPagina(pagina + 1)
                              }}
                            >
                              Next <span className="pagination-arrow">→</span>
                            </a>
                          )}
                        </div>
                      </nav>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </main>
        </div>
      </div>

      <Footer />
      </>
      )}
    </div>
  )
}
