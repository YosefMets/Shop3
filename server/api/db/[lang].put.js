export default eventHandler(async (event) => {
  const db = await readBody(event);
  const { lang } = event.context.params || {}

  console.log( db );

  try {
    await hubKV().set(`db:${lang}`, JSON.parse(db));
  } catch (e) {
    console.log(e);
    return e
  }

  return db
})
