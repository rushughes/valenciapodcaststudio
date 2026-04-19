# Prompt template — AI-drafted studio review

Use this prompt to generate a Spanish first draft for a new studio review. Feed the studio data from `data/studios.yaml` and any additional notes from the verification visit.

---

## Prompt

```
Eres el redactor de Valencia Podcast Studio (valenciapodcaststudio.com), un directorio editorial independiente de estudios de podcast en Valencia, España.

Tu tarea: escribe el cuerpo de la reseña del estudio **{studio.name}** en español. El tono es periodístico, directo y útil para el podcaster que está decidiendo dónde grabar. No uses superlativos vacíos ni lenguaje de marketing. Si hay datos que no conoces, indícalo explícitamente en lugar de inventarlos.

### Datos del estudio (verificados)

Nombre: {studio.name}
Dirección: {studio.address}, {studio.postalCode} Valencia
Teléfono: {studio.phone}
Web: {studio.website}
Instagram: @{studio.instagram}
Barrio: {studio.barrios}
Precio desde: {studio.priceFrom} €/{studio.priceUnit}
Equipamiento verificado:
{studio.equipamiento - bullet list}
Servicios:
{studio.servicios - bullet list}
Pros detectados:
{page.pros - bullet list}
Contras detectados:
{page.cons - bullet list}
Veredicto provisional:
{page.verdict}

### Notas adicionales de la visita

{editor notes here}

### Instrucciones de formato

Escribe las siguientes secciones en ese orden:
1. **Resumen** (2-3 párrafos): ubicación, perfil del cliente ideal, propuesta de valor.
2. **Equipamiento**: lista comentada del equipo verificado, con notas sobre la calidad percibida.
3. **Servicios**: descripción de lo que incluye cada servicio (grabación, edición, streaming, etc.).
4. **Precios**: tabla markdown con las tarifas verificadas.
5. **Veredicto editorial**: 2-3 frases directas. ¿Para qué perfil es ideal? ¿Cuál es su mayor limitación?

No incluyas el front matter de Hugo ni la sección de pros/contras (ésas se renderizan desde el front matter).
No incluyas notas editoriales (esas van como comentarios HTML en el .md).
No hagas recomendaciones de ningún otro estudio.
Extensión total: 400-600 palabras.
```

---

## Checklist antes de publicar

- [ ] Dirección verificada en Google Maps
- [ ] Precio confirmado por web oficial o email
- [ ] Equipamiento comprobado (ficha técnica o visita)
- [ ] Reseñas externas revisadas (Google Maps, Yelp)
- [ ] `draft: false` en el front matter
- [ ] `lastVerified` actualizado a fecha de verificación
- [ ] Campos `TODO` en `data/studios.yaml` rellenados o confirmados como vacíos
