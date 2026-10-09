export default [
    { name: 'empty', items: [] },
    { name: 'zero', items: [0] },
    { name: 'singleton', items: [11] },
    { name: 'pair', items: [11, 9] },
    { name: 'ordered', items: [0, 1, 2, 3, 4, 5] },
    { name: 'reversed', items: [5, 4, 3, 2, 1, 0] },
    { name: 'repeated', items: [7, 7, 7, 7] },
    { name: 'signed', items: [-11, 0, 11, -1] },
    { name: 'alternating', items: [-3, 3, -3, 3] },
    { name: 'plateau', items: [1, 4, 4, 2, 7, 0, 9] },
    { name: 'growth_257', items: Array.from({ length: 257 }, (_, index) => (index % 17) - 8) },
    { name: 'growth_1024', items: Array.from({ length: 1024 }, (_, index) => (index % 31) - 15) }
]
