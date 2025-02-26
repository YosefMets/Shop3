export default eventHandler(async (event) => {
  const { lang } = event.context.params || {}
  return hubKV().get(`db:${lang}`);
})
