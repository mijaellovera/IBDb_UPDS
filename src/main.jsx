import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import Library from './Library.jsx'
import '@fortawesome/fontawesome-free/css/all.min.css';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Library />
  </StrictMode>,
)
