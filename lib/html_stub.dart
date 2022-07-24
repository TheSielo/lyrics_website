const htmlStart = """<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->
<head>

  <!-- Basic Page Needs
  ================================================== -->
	<meta charset="utf-8">
	<title></title>
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Mobile Specific Metas
  ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<!-- CSS
  ================================================== -->
  <link rel="stylesheet" href="">

	<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

	<!-- Favicons
	================================================== -->
	<link rel="shortcut icon" href="">

	<style>
		p {
			font-family: Calibri, 'Trebuchet MS', sans-serif;
			font-size: 36px;
			margin: 100px;
		}

		@media (max-width:840px){
			p {
				font-size: 24px;
				margin: 10px
			}
		}
	</style>
</head>
<body>

  <!-- Primary Page Layout
	================================================== -->
  <p>
""";

const htmlEnd = """</p>

<!-- End Document
================================================== -->
</body>
</html>""";