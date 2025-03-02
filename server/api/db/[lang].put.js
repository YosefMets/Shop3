export default eventHandler(async (event) => {
  const db = await readBody(event);
  const { lang } = event.context.params || {}

  try {
    await hubKV().set(`db:${lang}`, JSON.stringify(db));
  } catch (e) {
    console.log(e);
    return e
  }

  const qwe = await hubKV().get(`db:${lang}`);
  // const asd = JSON.parse(qwe);

  console.log( 111, db, qwe );

  return qwe;
})
