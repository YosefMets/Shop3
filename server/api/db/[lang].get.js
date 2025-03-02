export default eventHandler(async (event) => {
  const { lang } = event.context.params || {}
  // event.headers.append('content-type', 'json');
  return hubKV().get(`db:${lang}`);
})
