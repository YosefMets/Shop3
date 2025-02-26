export default eventHandler(async (event) => {
  const db = await readBody(event)
  await hubKV().set('db', db);

  return db
})
