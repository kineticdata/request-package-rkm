<%-- Include the package initialization file. --%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc)
    catalog.preload(context);
    
%>

<%
    //Record that this article was viewed

    // Retrieve the article id url parameter and use it to retrieve the
    // general knowledge article.  Fields from this record will be used
    // when populating the action below.
    String articleId = request.getParameter("articleId");
    String relevanceType = "VIEWARTICLE";
    KnowledgeArticle article = KnowledgeArticle.findById(serverUser, articleId);

    // Create the entry that will represent the SYS:Action record.  Each
    // of the fields that is populated is either populated by a constant
    // value, or is derived from the knowledge article retrieved above.
    com.bmc.arsys.api.Entry entry = new com.bmc.arsys.api.Entry();
    // ID01 InstanceId, set to Instance Id of Knowledge Article
    entry.put(1000005888, new com.bmc.arsys.api.Value(article.getInstanceId()));
    // Start Date 01, set to the current time
    entry.put(1000005080, new com.bmc.arsys.api.Value(System.currentTimeMillis() / 1000));
    // Action, set to USEARTICLE or VIEWARTICLE
    entry.put(1000001151, new com.bmc.arsys.api.Value(relevanceType));
    // Request ID02, set o to Doc ID of Knowledge Article
    entry.put(1000000205, new com.bmc.arsys.api.Value(article.getDocId()));
    // Request ID01, set to Request ID of Knowledge Article
    entry.put(1000000204, new com.bmc.arsys.api.Value(article.getId()));
    // Form Name01, set to the form name of the knowledege article form
    entry.put(1000000101, new com.bmc.arsys.api.Value("RKM:KnowledgeArticleManager"));
    // Description, set to Article Title (100 character max) of Knowledge Article
    String truncatedTitle;
    if (article.getTitle() != null && article.getTitle().length()>100) {
        truncatedTitle = article.getTitle().substring(0, 100);
    } else {
        truncatedTitle = article.getTitle();
    }
    entry.put(1000000000, new com.bmc.arsys.api.Value(truncatedTitle));
    // Request ID03, set to Company of Knowledge Article
    entry.put(304080700, new com.bmc.arsys.api.Value(article.getCompany()));
    // Submitter, set to the current user name
    entry.put(2, new com.bmc.arsys.api.Value(context.getUserName()));
    
    // Save the entry
    System.out.println("Starting SYS:Action Entry: " + articleId);
    serverUser.createEntry("SYS:Action", entry);
    System.out.println("Ending SYS:Action Entry: " + articleId);
%>


<%-- Include the bundle js config initialization. --%>
<%@include file="../../../../core/interface/fragments/packageJsInitialization.jspf" %>

        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>assets/css/rkm.css" type="text/css" />
        <link rel="stylesheet" href="<%= bundle.packagePath()%>assets/css/rkmArticle.css" type="text/css" />
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>assets/js/rkmArticle.js"></script>
    
                    <header class="container">
                        <h3>
                            <%=themeLocalizer.getString("Knowledge Article")%>
                        </h3>
                    </header>
                    <section class="container">
                        <ul class="portlets unstyled">
                            <li class="border-top col-sm-6 wide" id="knowledgeSearch">
                                <div class="content-wrap"> 
                                    <div class="description-wide">
                                        <h3><div class="title" id="article-title"><%=request.getParameter("articleId")%>: </div> <i class="fa fa-cart"></i></h3>
                                        <div class="portlet-content rkm">
                                            <div class="clearfix" id="article-content">
                                            </div>
                                        <div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </section>