#####
# Draw Sankey diagrams with one function, sankey().
# By Nathan Yau, http://flowingdata.com
#####


# Helper function: Find depth of leaf.
findDepth <- function(leaf, thedata) {
    
    currDepth <- 1
    parent <- thedata[thedata$name == leaf,]$parent
    while(parent != '') {
        
        currDepth <- currDepth + 1
        parent <- thedata[thedata$name == parent,]$parent
    }
    
    return(currDepth)
}


sankey <- function(thedata, col="#821122", showLabels=TRUE) {
    
    yParTop <- list()
    depths <- c()
    
    for (i in 1:length(thedata[,1])) {
        depths <- c(depths, findDepth(thedata[i,]$name, thedata))
    }
    thedata$depth <- depths
    maxdepth <- max(depths)
    startTotal <- max(thedata$value)
    
    # Sort appropriately for upcoming iteration, first depth then value.
    thedata <- thedata[with(thedata, order(depth, -value)),]
    
    # Get your Sankey on.
    plot(0, 0, xlim=c(0, maxdepth+1), ylim=c(-startTotal/10, startTotal), type="n", xlab="depth", ylab="value")
    for (i in 1:maxdepth) {
    	
    	# Get leaves at current depth i
    	leaves <- thedata[thedata$depth == i,]
    	x <- leaves$depth
    	y <- leaves$value
        
        # Draw a rectangle for each leaf.
    	for (j in 1:length(leaves[,1])) {

    		# If first leaf i.e. the root
    		if (leaves[j,]$parent == '') {

    			# Draw rectangle from zero to value.
    			x1 <- i - 1         
    			y1 <- 0             
    			x2 <- i + 0.01      # Buffer to add overlap
    			y2 <- startTotal    # Padding for top border
    			rect(x1, y1, x2, y2, col=col, border=col)
                lines(c(x1, x2), c(y2, y2), col="#ffffff", lwd=0.7)

    			# Add label.
    			if (showLabels) {
    			    
    			    # Midpoint of leaf
    			    xMid <- (x1 + x2) / 2
                    yMid <- (y1 + y2) / 2
                    text(xMid, yMid, paste(leaves[j,]$name, "\n(", leaves[j,]$value, ")", sep=""), cex=1, col="#000000")
    			}
                
                # Save location of rectangle top.
    			yParTop[[leaves[j,]$name]] <- startTotal
    			yTop <- startTotal

    		} else {

                # Draw leaf based on location of parent.
    			x1 <- i - 1
    			y1 <- yParTop[[leaves[j,]$parent]]-y[j]
    			x2 <- i
    			y2 <- yParTop[[leaves[j,]$parent]]
    			rect(x1, y1, x2+0.01, y2, col=col, border=col)
    			lines(c(x1, x2), c(y2, y2), col="#ffffff", lwd=0.7)

    			# Add label.
                if (showLabels) {
                    xMid <- (x1 + x2) / 2
                    yMid <- (y1 + y2) / 2
                    text(xMid, yMid-1, leaves[j,]$name, cex=1.5/i, col="#000000")
                }

    			# Set y offset.
    			yTop <- yParTop[[leaves[j,]$parent]]

    			# Check if leaf has children.
    			if (leaves[j,]$name %in% thedata$parent) {
                    
                    # Do nothing for now.

    			} else {    # Current leaf has no children.

    				# Draw downward shape to show end.
    				x1 <- i
    				y1 <- yTop - 1
    				x2 <- x1 + 0.4
    				y2 <- y1 - startTotal/10 - 1

    				x4 <- x1
    				y4 <- y1 - y[j] + 1

    				m <- (y2 - y1) / (x2 - x1)
    				b <- y4 - m * x4

    				y3 <- y4 - startTotal/10
    				x3 <- (y3 - b) / m

    				polygon(c(x1, x2, x3, x4), c(y1, y2, y3, y4), col=col, border=col)
    				lines(c(x1, x2), c(y1, y2), col="#ffffff", lwd=0.7)

    			} # @end if leaf has children

                # Store parent offsets for next iteration.
    			yParTop[[leaves[j,]$name]] <- yParTop[[leaves[j,]$parent]]
    			yParTop[[leaves[j,]$parent]] <- yParTop[[leaves[j,]$parent]] - y[j]
    		}

    		# Get sum of child leaves, if they exist.
            childrenSum <- sum(thedata[thedata$parent == leaves[j,]$name,]$value)

            # If parent leftover after leaves, show remainder.
            if (childrenSum < yTop) {
    			x1 <- i
    			y1 <- yTop - childrenSum
    			x2 <- x1 + 0.4
    			y2 <- y1 - startTotal/10

    		    x4 <- x1
            	y4 <- yTop - leaves[j,]$value

            	m <- (y2 - y1) / (x2 - x1)
            	b <- y4 - m * x4

    			y3 <- y4 - startTotal/10
    			x3 <- (y3 - b) / m

    			polygon(c(x1, x2, x3, x4), c(y1, y2, y3, y4), col=col, border=NA)
    			lines(c(x1, x2), c(y1, y2), col="#ffffff", lwd=0.7)

            } # @end if childrenSum

    	} # @end for leaves

    }
}
