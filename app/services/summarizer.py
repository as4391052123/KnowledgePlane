from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans

def categorize_knowledge(data):
    vectorizer = TfidfVectorizer(stop_words='english')
    X = vectorizer.fit_transform(data)
    model = KMeans(n_clusters=5)
    model.fit(X)
    labels = model.labels_
    return labels
