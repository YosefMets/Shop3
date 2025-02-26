export default eventHandler(async (event) => {
  const db = await readBody(event);

  console.log( db );

  try {
    await hubKV().set('db', db);
  } catch (e) {
    console.log(e);
    return e
  }

  return db
})
