  
Project Outline
========================================================

SwiftKey is a company that has created a smart keyboard application for mobile devices that uses a blend of artificial intelligence technologies that enable it to predict the next word the user intends to type.

The goal of this project is to build a predictive text model, like those used by SwiftKey, to suggest the next word when a user types in a partial sentence. 

Project outline:
- Acquire, cleanse & explore the data
- Build & test predictive model
- Create web interface & presentation

Predictive Text Model Algorithm
========================================================

The model utilizes the maximum likelihood estimation (MLE) to estimate N-gram probabilities. To estimate probabilities MLE uses the relative frequency ratio:

$$ \Large{ P \left( w_n|w_{n-1} \right) = \frac{C(w_{n-1}w_n)}{C(w_{n-1})} }$$`

To simplify predictions where the N-gram which was input by the user is not found in the data sample, the model also utilizes the Stupid Backoff algorithm. Stupid Backoff works under the assumption that "if a higher order N-gram has a zero count, we simply backoff to a lower order N-gram, weighted by a fixed weight (lambda)." The fixed weight the model uses for lambda is .4 which has been known to work well for this algorithm.

Web Application Instructions
========================================================

The web app can be found at:
https://akorsakovabain.shinyapps.io/SwiftkeyCapstone/

The simple interface allows the user to input a sentence into the text box on the left and simply click the "Give me the predictions!" button. At that time, the model will calculate the three words with the highest probability using the relative frequency ratio described in the previous slide and present them to the user.

The application uses a sample of approximately 60,000 Tweets, news articles, and blog entries. The original algorithm pruned the sample once it was divided into 4, 3, 2, and one-grams but it was not necessary for speed and space purposes and drove down the accuracy. Thus the pruning was removed.

References and Links
========================================================

Maximum Likelihood Estimation, Stupid Backoff, and Pruning are all concepts covered in the "Speech and Language Processing" paper which can be found at https://lagunita.stanford.edu/c4x/Engineering/CS-224N/asset/slp4.pdf

The exploratory analysis of the dataset performed earlier in the project can be found at: http://rpubs.com/akorsakova/milestonereport

Github repository containing the complete commented code can be found at: https://github.com/akorsakova/CourseraCapstone

