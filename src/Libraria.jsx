import { useState } from 'react'
import './Libraria.css'

const gridBooks = [
  { img: 'images/books-media/gird-view/book-media-grid-01.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'blue-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-02.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'blue-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-03.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'red-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-04.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'yellow-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-05.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'red-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-06.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'green-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-07.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'light-green-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-08.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'green-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-09.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'yellow-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-10.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'light-green-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-11.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'yellow-icon' },
  { img: 'images/books-media/gird-view/book-media-grid-12.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'red-icon' },
]

const fullBooks = [
  { img: 'images/books-media/layout-3/books-media-layout3-01.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'blue-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-02.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'yellow-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-03.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'green-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-04.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'yellow-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-05.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'blue-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-06.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'red-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-07.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'green-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-08.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'light-green-icon' },
  { img: 'images/books-media/layout-3/books-media-layout3-09.jpg', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', isbn: '9781581573268', color: 'red-icon' },
]

const navLinks = [
  { label: 'Autores', href: '#autores' },
  { label: 'Categorias', href: '#categorias' },
  { label: 'Novedades', href: '#novedades' },
  { label: 'Destacados', href: '#destacados' },
]

function Header() {
  return (
    <header id="header-v1" className="navbar-wrapper inner-navbar-wrapper">
      <div className="container">
        <div className="row">
          <nav className="navbar navbar-default">
            <div className="row">
              <div className="col-md-3">
                <div className="navbar-header">
                  <div className="navbar-brand">
                    <h1><a href="index-2.html"><img src="images/books-media/gird-view/book-media-grid-01.jpg" alt="LIBRARIA" style={{ maxHeight: 40 }} /></a></h1>
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
                        <form className="header-search-form" onSubmit={(e) => e.preventDefault()}>
                          <input type="text" placeholder="Buscar..." />
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
        <img src={book.img} alt="Book" />
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
              <li><a href="#"><i className="fa fa-google-plus"></i></a></li>
              <li><a href="#"><i className="fa fa-rss"></i></a></li>
              <li><a href="#"><i className="fa fa-linkedin"></i></a></li>
            </ul>
          </div>
          <div className="optional-links">
            <ul>
              <li><a href="#"><i className="fa fa-shopping-cart"></i></a></li>
              <li><a href="#"><i className="fa fa-heart"></i></a></li>
              <li><a href="#"><i className="fa fa-envelope"></i></a></li>
              <li><a href="#"><i className="fa fa-search"></i></a></li>
              <li><a href="#"><i className="fa fa-print"></i></a></li>
            </ul>
          </div>
          <header className="entry-header">
            <h3 className="entry-title"><a href="#">{book.title}</a></h3>
            <ul>
              <li><strong>Author:</strong> {book.author}</li>
              <li><strong>ISBN:</strong> {book.isbn}</li>
            </ul>
          </header>
          <div className="entry-content">
            <p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don&#39;t look even slightly believable.</p>
          </div>
          <footer className="entry-footer">
            <a className="btn btn-primary" href="#">Read More</a>
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
        <a href="#"><img src={book.img} alt="Book" /></a>
        <figcaption>
          <header>
            <h4><a href="#">{book.title}</a></h4>
            <p><strong>Author:</strong> {book.author}</p>
            <p><strong>ISBN:</strong> {book.isbn}</p>
          </header>
          <p>It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. Pellentesque dolor turpis, pulvinar varius.</p>
          <div className="actions">
            <ul>
              <li><a href="#"><i className="fa fa-shopping-cart"></i></a></li>
              <li><a href="#"><i className="fa fa-heart"></i></a></li>
              <li><a href="#"><i className="fa fa-envelope"></i></a></li>
              <li><a href="#"><i className="fa fa-search"></i></a></li>
              <li><a href="#"><i className="fa fa-print"></i></a></li>
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
                <img src="images/books-media/gird-view/book-media-grid-01.jpg" alt="Logo" style={{ maxHeight: 50 }} />
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

  return (
    <div>
      <Header />

      <section className="page-banner services-banner">
        <div className="container">
          <div className="banner-header">
            <h2>Books & Media Listing</h2>
            <span className="underline center"></span>
            <p className="lead">Proin ac eros pellentesque dolor pharetra tempo.</p>
          </div>
          <div className="breadcrumb">
            <ul>
              <li><a href="#">Home</a></li>
              <li>Books & Media</li>
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
                          <select name="orderby">
                            <option>Default sorting</option>
                            <option>Sort by popularity</option>
                            <option>Sort by rating</option>
                            <option>Sort by newness</option>
                            <option>Sort by price</option>
                          </select>
                        </div>
                        <div className="col-md-4 col-sm-4">
                          <div className="filter-result">Showing items 1 to 9 of 19 total</div>
                        </div>
                        <div className="col-md-3 col-sm-3 pull-right">
                          <div className="filter-toggle">
                            <a href="#" className={view === 'grid' ? 'active' : ''} onClick={(e) => { e.preventDefault(); setView('grid') }}>
                              <i className="glyphicon glyphicon-th-large"></i>
                            </a>
                            <a href="#" className={view === 'full' ? 'active' : ''} onClick={(e) => { e.preventDefault(); setView('full') }}>
                              <i className="glyphicon glyphicon-th-list"></i>
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>

                    {view === 'grid' ? (
                      <div className="books-gird">
                        <ul>
                          {gridBooks.map((book, i) => (
                            <GridBookItem key={i} book={book} />
                          ))}
                        </ul>
                      </div>
                    ) : (
                      <div className="booksmedia-fullwidth">
                        <ul>
                          {fullBooks.map((book, i) => (
                            <FullWidthBookItem key={i} book={book} />
                          ))}
                        </ul>
                      </div>
                    )}

                    <nav className="navigation pagination text-center">
                      <h2 className="screen-reader-text">Posts navigation</h2>
                      <div className="nav-links">
                        <a className="prev page-numbers" href="#"><i className="fa fa-long-arrow-left"></i> Previous</a>
                        <a className="page-numbers" href="#">1</a>
                        <span className="page-numbers current">2</span>
                        <a className="page-numbers" href="#">3</a>
                        <a className="page-numbers" href="#">4</a>
                        <a className="next page-numbers" href="#">Next <i className="fa fa-long-arrow-right"></i></a>
                      </div>
                    </nav>
                  </div>
                </div>
              </div>
            </div>
          </main>
        </div>
      </div>

      <Footer />
    </div>
  )
}
