

**Grandpa is moody, will his cognition decline?** Predicting cognitive and neural decline in Parkinson's disease from non-motor symptoms evolution
==========================================================================================================================================================

| Welcome to the documentation of my Brainhack 2024 project! 
| You will find the project deliverables here, in the form of 3 pipelines *(.ipynb)*, each performing different tasks.

Project overview
-------------------
Here is an overview of the project: 

.. figure:: /images/project_overview.png

| The idea is to identify different patterns (subtypes) of **non-motor symptoms progression** in Parkinson's disease (PD) using a clustering algorithm (`SuStaIn <https://github.com/ucl-pond/pySuStaIn/tree/master>`_), and see whether a specific subtype is associated with faster **cognitive** and **neural decline**. 

| Early identification of individuals at higher risk of cognitive decline through their non-motor symptoms presentation can facilitate timely interventions.

Pipelines (deliverables)
---------------------------------
Three pipelines were written in Python to set up a workflow for the project.

Pipeline #1: Clustering
++++++++++++++++++++++++++++++
|   - Data visualization
|   - Preparing and adjusting algorithm inputs
|   - Running the algorithm
|   - Model stability tracking
|   - Model performance evaluation

Pipeline #2: Imaging
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
|   - Raw MRI conversion to BIDS
|   - Freesurfer preprocessing
|   - Manipulating neuroimaging data

Pipeline #3: Statistical analyses
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
|   - Descriptive statistics
|   - Statistical comparisons of cognitive and neural decline between identified clusters
|   - Visualization of results


.. toctree::
   :maxdepth: 1
   :caption: Contents:

   notebooks/pipeline_1.ipynb
   notebooks/pipeline_2.ipynb
   notebooks/pipeline_3.ipynb

