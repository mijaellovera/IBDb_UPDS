import { useEffect, useRef, useState } from 'react'
import './SelectedWorks.css'

const works = [
  {
    num: 'No. 01',
    category: 'Editorial',
    title: 'The quiet hour',
    titleItalic: 'quiet',
    desc: 'An interior study of late afternoon light, photographed across a single day in March.',
    img: 'images/selected-work-01.jpg',
    alt: 'Quiet Hour series — featured photograph',
  },
  {
    num: 'No. 02',
    category: 'Commission',
    title: 'Studies in linen',
    titleItalic: 'linen',
    desc: 'A small textile maison in Chiang Mai. Six weeks. Forty-three frames. Three published.',
    img: 'images/selected-work-02.jpg',
    alt: 'Studies in Linen — editorial commission',
  },
  {
    num: 'No. 03',
    category: 'Exhibition',
    title: 'Vessels & vessels',
    titleItalic: 'vessels',
    desc: 'Still-life work for a ceramicist\'s first European exhibition. Shown in Antwerp, autumn.',
    img: 'images/selected-work-03.jpg',
    alt: 'Vessels and Vessels — still life series',
  },
  {
    num: 'No. 04',
    category: 'Portrait',
    title: 'Hands at rest',
    titleItalic: 'rest',
    desc: 'A quiet portrait series for a slow-fashion campaign in Tokyo. Six artisans, photographed at work.',
    img: 'images/selected-work-04.jpg',
    alt: 'Hands at Rest — portrait series',
  },
]

function WorkCard({ work }) {
  const parts = work.title.split(work.titleItalic)
  return (
    <a className="workCard reveal" href="#">
      <div className="wcImg">
        <img src={work.img} alt={work.alt} />
      </div>
      <div className="wcMeta">
        <span className="num">{work.num}</span>
        <span>{work.category}</span>
      </div>
      <div className="wcTitle">
        {parts[0]}<em>{work.titleItalic}</em>{parts[1]}
      </div>
      <p className="wcDesc">{work.desc}</p>
      <span className="wcLink">View series &rarr;</span>
    </a>
  )
}

export default function SelectedWorks() {
  const [revealed, setRevealed] = useState(false)
  const ref = useRef(null)

  useEffect(() => {
    const timer = setTimeout(() => setRevealed(true), 100)
    return () => clearTimeout(timer)
  }, [])

  return (
    <section ref={ref} className={`selectedWorks ${revealed ? 'revealed' : ''}`}>
      <div className="worksHead">
        <h2 className="reveal">Selected <em>works</em></h2>
        <p className="lead reveal">
          Three commissions from this year that captured something of how the studio thinks.
          Each is a small story about light, time, and care.
        </p>
      </div>
      <div className="worksGrid">
        {works.map((work, i) => (
          <WorkCard key={i} work={work} />
        ))}
      </div>
    </section>
  )
}
