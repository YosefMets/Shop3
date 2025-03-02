import generateNestId from '~/composables/generateNestId.js'

export default eventHandler(async (event) => {
  const { text } = await readBody(event)
  const db = hubDatabase()

  const insertRes = await db
    .prepare('INSERT INTO messages (text, created_at) VALUES (?1, ?2)')
    .bind(text, Date.now())
    .run();

  const lastRow = insertRes?.meta?.last_row_id;
  const nestId = generateNestId( lastRow, 'M' );
  await db
    .prepare('UPDATE messages SET nestId = ?1 WHERE id = ?2')
    .bind(nestId, lastRow)
    .run();

  // console.log('lastRow', nestId);

  return {}
})
