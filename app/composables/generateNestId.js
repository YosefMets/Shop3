export default ( increment, prefix = '', length = 4 ) => {

  const id = increment.toString(36).toUpperCase();
  return prefix + '0'.repeat( length - id.length ) + id;


}
