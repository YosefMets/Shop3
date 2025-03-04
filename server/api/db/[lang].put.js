export default eventHandler(async (event) => {
  let db = await readBody(event);
  try { db = JSON.parse( db ) } catch (e) {}
  const { lang } = event.context.params || {};

  try {
    await hubKV().set(`db:${lang}`, db);
  } catch (e) {
    console.log(e);
    return e
  }

  const qwe = await hubKV().get(`db:${lang}`);
  // const asd = JSON.parse(qwe);

  console.log( 111, db, qwe );

  return qwe;
})
