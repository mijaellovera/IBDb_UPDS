import { useEffect, useState } from 'react'
import './Libraria.css'
import { obtenerLibros } from './librariaApi'
import Admin from './Admin'

const navLinks = [
  { label: 'Autores', href: '#autores' },
  { label: 'Categorias', href: '#categorias' },
  { label: 'Novedades', href: '#novedades' },
  { label: 'Destacados', href: '#destacados' },
]

function Header({ buscar, onBuscar, onAdmin }) {
  const [texto, setTexto] = useState(buscar)
  return (
    <header id="header-v1" className="navbar-wrapper inner-navbar-wrapper">
      <div className="container">
        <div className="row">
          <nav className="navbar navbar-default">
            <div className="row">
              <div className="col-md-3">
                <div className="navbar-header">
                  <div className="navbar-brand">
                    <h1><a href="/"><img src="/images/books-media/gird-view/book-media-grid-01.jpg" alt="LIBRARIA" style={{ maxHeight: 40 }} /></a></h1>
                  </div>
                </div>
              </div>
              <div className="col-md-9">
                <div className="header-topbar hidden-sm hidden-xs">
                  <div className="row">
                    <div className="col-sm-6">
                      <div className="topbar-info">
                        <a href="tel:+61-3-8376-6284"><i className="fa fa-phone"></i>+61-3-8376-6284</a>
                        <span>/</span>
                        <a href="mailto:support@libraria.com"><i className="fa fa-envelope"></i>support@libraria.com</a>
                      </div>
                    </div>
                    <div className="col-sm-6">
                      <div className="topbar-links">
                        <a href="#" className="admin-toggle" onClick={(e) => { e.preventDefault(); onAdmin() }} style={{ marginRight: 12, fontWeight: 600 }}>Admin</a>
                        <form className="header-search-form" onSubmit={(e) => { e.preventDefault(); onBuscar(texto) }}>
                          <input type="text" placeholder="Buscar..." value={texto} onChange={(e) => setTexto(e.target.value)} />
                          <button type="submit"><i className="fa fa-search"></i></button>
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="navbar-collapse hidden-sm hidden-xs">
                  <ul className="nav navbar-nav">
                    {navLinks.map((link, i) => (
                      <li key={i} className={i === 0 ? 'dropdown active' : 'dropdown'}>
                        <a href={link.href}>{link.label}</a>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>
            <div className="mobile-menu hidden-lg hidden-md">
              <a href="#mobile-menu"><i className="fa fa-navicon"></i></a>
            </div>
          </nav>
        </div>
      </div>
    </header>
  )
}

function GridBookItem({ book }) {
  return (
    <li>
      <figure>
        <img src={book.img} alt={book.title} />
        <figcaption>
          <p><strong>{book.title}</strong></p>
          <p><strong>Author:</strong> {book.author}</p>
        </figcaption>
      </figure>
      <div className={`book-list-icon ${book.color}`}></div>
      <div className="single-book-box">
        <div className="post-detail">
          <div className="books-social-sharing">
            <ul>
              <li><a href="#"><i className="fa fa-facebook"></i></a></li>
              <li><a href="#"><i className="fa fa-twitter"></i></a></li>
              <li><a href="#"><i className="fa fa-rss"></i></a></li>
            </ul>
          </div>
          <div className="optional-links">
            <ul>
              <li><a href="#"><i className="fa fa-heart"></i></a></li>
              <li><a href={book.enlace || '#'} target="_blank" rel="noreferrer"><i className="fa fa-book"></i></a></li>
              <li><a href="#"><i className="fa fa-search"></i></a></li>
            </ul>
          </div>
          <header className="entry-header">
            <h3 className="entry-title"><a href="#">{book.title}</a></h3>
            <ul>
              <li><strong>Author:</strong> {book.author}</li>
              {book.isbn && <li><strong>ISBN:</strong> {book.isbn}</li>}
              {book.year && <li><strong>Año:</strong> {book.year}</li>}
              {book.rating && <li><strong>Rating:</strong> {book.rating} / 5 ({book.votos} votos)</li>}
            </ul>
          </header>
          <div className="entry-content">
            <p>{book.categorias?.length ? book.categorias.join(', ') : 'Clásico disponible para lectura online.'}</p>
          </div>
          <footer className="entry-footer">
            {book.enlace && (
              <a className="btn btn-primary" href={book.enlace} target="_blank" rel="noreferrer">
                Leer en Archive.org
              </a>
            )}
          </footer>
        </div>
      </div>
    </li>
  )
}

function FullWidthBookItem({ book }) {
  return (
    <li>
      <div className={`book-list-icon ${book.color}`}></div>
      <figure>
        <a href="#"><img src={book.img} alt={book.title} /></a>
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

function Footer() {
  return (
    <footer className="site-footer">
      <div className="container">
        <div className="footer-simple">
          <div className="row">
            <div className="col-md-3 col-sm-6">
              <div className="footer-logo">
                <img src="/images/books-media/gird-view/book-media-grid-01.jpg" alt="Logo" style={{ maxHeight: 50 }} />
              </div>
            </div>
            <div className="col-md-6 col-sm-6">
              <div className="footer-about">
                <h3>Acerca de Nosotros</h3>
                <p>Somos una biblioteca dedicada a la difusion del conocimiento y la cultura, ofreciendo a nuestra comunidad un espacio de acceso libre a la informacion y la lectura.</p>
              </div>
            </div>
            <div className="col-md-3 col-sm-12">
              <div className="footer-social">
                <span className="social-icon"><i className="fa fa-facebook-f"></i></span>
                <span className="social-icon"><i className="fa fa-twitter"></i></span>
                <span className="social-icon"><i className="fa fa-instagram"></i></span>
                <span className="social-icon"><i className="fa fa-youtube"></i></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}

export default function Libraria() {
  const [view, setView] = useState('grid')
  const [libros, setLibros] = useState([])
  const [total, setTotal] = useState(0)
  const [orden, setOrden] = useState('default')
  const [buscar, setBuscar] = useState('')
  const [pagina, setPagina] = useState(1)
  const [cargando, setCargando] = useState(true)
  const [panelAdmin, setPanelAdmin] = useState(false)
  const [fuente, setFuente] = useState('mysql')
  const porPagina = view === 'grid' ? 12 : 9
  const totalPaginas = Math.max(1, Math.ceil(total / porPagina))

  useEffect(() => {
    let activo = true
    setCargando(true)
    obtenerLibros({ buscar, orden, pagina, porPagina })
      .then(({ total, libros, fuente }) => {
        if (!activo) return
        setLibros(libros)
        setTotal(total)
        setFuente(fuente)
      })
      .catch(console.error)
      .finally(() => activo && setCargando(false))
    return () => { activo = false }
  }, [buscar, orden, pagina, porPagina])

  return (
    <div>
      <Header
        buscar={buscar}
        onBuscar={(t) => { setBuscar(t); setPagina(1) }}
        onAdmin={() => setPanelAdmin(true)}
      />

      {panelAdmin && <Admin volver={() => setPanelAdmin(false)} />}

      {!panelAdmin && (
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
                    <div className="filter-options margin-list">
                      <div className="row">
                        <div className="col-md-4 col-sm-4">
                          <select name="orderby" value={orden} onChange={(e) => { setOrden(e.target.value); setPagina(1) }}>
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
                          <div className="filter-toggle">
                            <a href="#" className={view === 'grid' ? 'active' : ''} onClick={(e) => { e.preventDefault(); setView('grid'); setPagina(1) }}>
                              <i className="glyphicon glyphicon-th-large"></i>
                            </a>
                            <a href="#" className={view === 'full' ? 'active' : ''} onClick={(e) => { e.preventDefault(); setView('full'); setPagina(1) }}>
                              <i className="glyphicon glyphicon-th-list"></i>
                            </a>
                          </div>
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
                            <GridBookItem key={book.id} book={book} />
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
                            <a className="prev page-numbers" href="#" onClick={(e) => { e.preventDefault(); setPagina(pagina - 1) }}>
                              <i className="fa fa-long-arrow-left"></i> Previous
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
                            <a className="next page-numbers" href="#" onClick={(e) => { e.preventDefault(); setPagina(pagina + 1) }}>
                              Next <i className="fa fa-long-arrow-right"></i>
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
