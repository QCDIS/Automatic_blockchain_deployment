<template>
  <footer class="footer">
    <div class="container-fluid">
      <ul class="nav">
        <!-- <li class="nav-item">
          <a class="nav-link" href="https://www.linkedin.com/in/jardenna-mohazzab-461447122/">
            Jardenna Mohazzab
          </a>
        </li> -->
        <li class="nav-item">
          <!-- <a class="nav-link" href="">
            Licenses
          </a> -->
        </li>
      </ul>
      <div class="copyright">
        <!-- © -->
         {{year}} created by
        <a href="https://www.linkedin.com/in/jardenna-mohazzab-461447122/" target="_blank" rel="noopener">Jardenna Mohazzab</a>
      </div>
    </div>
  </footer>
</template>
<script>
  export default {
    data() {
      return {
        year: new Date().getFullYear()
      }
    }
  };
</script>
<style>
</style>
