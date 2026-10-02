import type { Category } from '../lib/types'

export const CATEGORIES: { id: Category; label: string }[] = [
  { id: 'tops', label: 'Tops' },
  { id: 'bottoms', label: 'Bottoms' },
  { id: 'dresses', label: 'Dresses & one-pieces' },
  { id: 'outerwear', label: 'Outerwear' },
  { id: 'shoes', label: 'Shoes' },
  { id: 'bags', label: 'Bags' },
  { id: 'jewellery', label: 'Jewellery & watches' },
  { id: 'accessories', label: 'Accessories' },
]

export const categoryLabel = (id: Category) => CATEGORIES.find((c) => c.id === id)!.label
